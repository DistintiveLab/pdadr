# estimar(): estimativas ponderadas

d_num <- data.frame(
  localidade = c("5301", "5301", "5302", "5302"),
  renda = c(10, 20, 30, NA),
  peso_dom = c(1, 3, 2, 5)
)

test_that("estimar() calcula média ponderada por grupo", {
  res <- estimar(d_num, "renda", tipo = "media", por = "localidade")
  expect_s3_class(res, "tbl_df")
  expect_identical(nrow(res), 2L)
  r <- setNames(res$estimativa, res$localidade)
  expect_equal(unname(r["5301"]), (10 * 1 + 20 * 3) / 4)
  expect_equal(unname(r["5302"]), 30)  # NA removido com o peso associado
  expect_identical(res$n, c(2L, 1L))
})

test_that("estimar() calcula total ponderado", {
  res <- estimar(d_num, "renda", tipo = "total")
  expect_equal(res$estimativa, 10 + 60 + 60)
})

test_that("estimar() calcula proporções de variável qualitativa", {
  d <- data.frame(cat = c("a", "a", "b"), peso_mor = c(2, 1, 1))
  res <- estimar(d, "cat", tipo = "proporcao")
  expect_named(res, c("nivel", "estimativa", "n"))
  p <- setNames(res$estimativa, res$nivel)
  expect_equal(unname(p["a"]), 0.75)
  expect_equal(unname(p["b"]), 0.25)
  # soma das proporções é 1
  expect_equal(sum(res$estimativa), 1)
})

test_that("estimar() calcula proporções desagregadas por grupo", {
  d <- data.frame(g = c("x", "x", "y"),
                  cat = c("a", "a", "b"),
                  peso_mor = c(2, 1, 1))
  res <- estimar(d, "cat", tipo = "proporcao", por = "g")
  expect_named(res, c("g", "nivel", "estimativa", "n"))
  p <- setNames(res$estimativa, paste(res$g, res$nivel))
  expect_equal(unname(p["x a"]), 1)
  expect_equal(unname(p["y b"]), 1)
})

test_that("estimar() trata lógicos e 0/1 como média ponderada", {
  d <- data.frame(ok = c(TRUE, FALSE), peso_mor = c(3, 1))
  expect_equal(estimar(d, "ok", tipo = "proporcao")$estimativa, 0.75)
  d2 <- data.frame(ok = c(1, 0, 1), peso_mor = c(1, 1, 2))
  expect_equal(estimar(d2, "ok", tipo = "proporcao")$estimativa, 0.75)
})

test_that("estimar() respeita na_rm", {
  d <- data.frame(renda = c(10, NA, 30), peso_dom = c(1, 3, 2))
  expect_equal(estimar(d, "renda")$estimativa, (10 + 60) / 3)
  expect_true(is.na(estimar(d, "renda", na_rm = FALSE)$estimativa))
})

test_that("estimar() infere e valida pesos e grupos", {
  expect_error(estimar(data.frame(x = 1), "x"), "pesos")
  # com os dois pesos presentes, exige escolha explícita
  amb <- data.frame(x = 1, peso_dom = 1, peso_mor = 1)
  expect_error(estimar(amb, "x"), "pesos")
  expect_equal(estimar(amb, "x", peso = "peso_mor")$estimativa, 1)
  expect_error(estimar(d_num, "renda", peso = "sem_peso"), "n\u00e3o encontrada")
  expect_error(estimar(d_num, "renda", por = "inexistente"), "ausente")
  expect_error(estimar(d_num, "variavel_que_nao_existe"), "n\u00e3o encontrada")
  # base de moradores inferida por exclusão
  dm <- data.frame(x = c(1, 2), peso_mor = c(1, 1))
  expect_equal(estimar(dm, "x", tipo = "total")$estimativa, 3)
})

# limpar_reservados(): códigos reservados -> NA

test_that("limpar_reservados() substitui códigos reservados", {
  d <- data.frame(
    renda = c(2000, 77777, 88888, 99999),
    cod = c(1, 2, 3, 4),
    texto = c("a", "b", "c", "77777"),
    peso_dom = c(1, 1, 1, 1)
  )
  res <- limpar_reservados(d)
  expect_equal(res$renda, c(2000, NA, NA, NA))
  expect_equal(res$cod, c(1, 2, 3, 4))        # valores pequenos preservados
  expect_equal(res$texto, c("a", "b", "c", "77777"))  # texto intacto
  expect_equal(res$peso_dom, rep(1, 4))
})

test_that("limpar_reservados() aceita conjunto próprio de códigos", {
  d <- data.frame(x = c(77777, 5))
  expect_equal(limpar_reservados(d, 77777)$x, c(NA, 5))
  expect_equal(limpar_reservados(d, 99999)$x, c(77777, 5))
})
