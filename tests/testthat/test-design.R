# design_pdad() e juntar_bases()

test_that("design_pdad() cria desenho ponderado com survey", {
  skip_if_not_installed("survey")
  d <- data.frame(renda = c(10, 20, 30), peso_dom = c(1, 3, 2))
  des <- design_pdad(d)
  expect_s3_class(des, "survey.design")
  expect_equal(as.numeric(survey::svytotal(~renda, des)), 130)
  expect_equal(as.numeric(survey::svymean(~renda, des)), 130 / 6)

  dm <- data.frame(idade = c(20, 40), peso_mor = c(2, 2))
  expect_s3_class(design_pdad(dm, base = "moradores"), "survey.design")
})

test_that("design_pdad() infere e valida a base", {
  expect_error(design_pdad(data.frame(x = 1)), "inferir")
  amb <- data.frame(x = 1, peso_dom = 1, peso_mor = 1)
  expect_error(design_pdad(amb), "inferir")
  expect_error(design_pdad(data.frame(x = 1), base = "domicilios"), "n\u00e3o encontrada")
})

test_that("design_pdad() repassa argumentos ao svydesign", {
  skip_if_not_installed("survey")
  d <- data.frame(estrato = c("a", "a", "b"), renda = c(10, 20, 30),
                  peso_dom = c(1, 3, 2))
  des <- design_pdad(d, strata = ~estrato)
  expect_s3_class(des, "survey.design")
})

ler_fixture <- function(arq) {
  utils::read.csv(file.path("fixtures", arq), sep = ";")
}

test_that("juntar_bases() cruza pela chave A01nficha", {
  dom <- ler_fixture("domicilios_mini.csv")
  mor <- ler_fixture("moradores_mini.csv")
  j <- juntar_bases(dom, mor)

  expect_s3_class(j, "tbl_df")
  expect_identical(nrow(j), nrow(mor))
  # colunas comuns aos dois lados recebem sufixos _mor/_dom
  expect_true(all(c("localidade_mor", "localidade_dom") %in% names(j)))
  expect_false("localidade" %in% names(j))
  # a chave permanece única por coluna e sem sufixo
  expect_true("A01nficha" %in% names(j))
  # valores da chave preservados
  expect_setequal(as.character(j$A01nficha), as.character(mor$A01nficha))
  # colunas não compartilhadas não são sufixadas
  expect_true("peso_dom" %in% names(j))
  expect_true("peso_mor" %in% names(j))
})

test_that("juntar_bases(como = 'completo') mantém chaves sem par", {
  dom <- data.frame(A01nficha = c(1, 2), localidade = c("5301", "5302"),
                    peso_dom = c(1, 1))
  mor <- data.frame(A01nficha = c(1), idade = c(30), peso_mor = 1)
  j <- juntar_bases(dom, mor, como = "completo")
  expect_identical(nrow(j), 2L)
  expect_true(is.na(j$idade[j$A01nficha == 2]))
})

test_that("juntar_bases() valida entrada", {
  dom <- ler_fixture("domicilios_mini.csv")
  mor <- ler_fixture("moradores_mini.csv")
  expect_error(juntar_bases(dom[, -2], mor), "A01nficha")
  expect_error(juntar_bases(rbind(dom, dom), mor), "duplicadas")
})
