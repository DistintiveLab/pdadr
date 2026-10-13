test_that("rotular() converte variáveis codificadas em factor", {
  dom <- data.table::fread(test_path("fixtures", "domicilios_mini.csv"),
                           sep = ";", encoding = "UTF-8")
  rot <- rotular(dom)

  expect_s3_class(rot$localidade, "factor")
  esperado <- dicionario(base = "domicilios", coluna = "localidade")
  expect_setequal(levels(rot$localidade), esperado$descricao_valor)
  # código 5301 vira "Plano Piloto"
  idx <- which(as.character(dom$localidade) == "5301")
  if (length(idx) > 0) {
    expect_equal(as.character(rot$localidade[idx]), "Plano Piloto")
  }

  # variável sem codificação permanece inalterada
  expect_type(rot$starttime, "character")
  # variável numérica derivada permanece numérica
  expect_type(rot$renda_domiciliar, "integer")
})

test_that("rotular() infere a base pelas colunas", {
  mor <- data.table::fread(test_path("fixtures", "moradores_mini.csv"),
                           sep = ";", encoding = "UTF-8")
  rot <- rotular(mor)
  # A01uf é codificada (52 Goiás, 53 Distrito Federal)
  expect_s3_class(rot$A01uf, "factor")
  expect_true("Distrito Federal" %in% levels(rot$A01uf))
  # localidade não é codificada no dicionário de moradores e permanece como veio
  expect_false(is.factor(rot$localidade))
})

test_that("rotular() com data.frame sem colunas-chave exige base", {
  df <- data.frame(x = 1)
  expect_error(rotular(df), "inferir")
})
