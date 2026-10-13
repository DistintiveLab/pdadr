# Linhas geradas automaticamente por usethis::use_testthat()
# Edite conforme necessário.

library(pdadr)
library(testthat)

test_that("dicionario() retorna a tabela de metadados", {
  tab <- dicionario()
  expect_s3_class(tab, "tbl_df")
  expect_true(all(c("domicilios", "moradores") %in% as.character(tab$base)))
  expect_equal(names(tab), c("base", "coluna", "descricao_coluna",
                             "valor", "descricao_valor", "anexo"))
})

test_that("dicionario() filtra por base", {
  mor <- dicionario(base = "moradores")
  expect_true(all(mor$base == "moradores"))
  expect_error(dicionario(base = "visitas"), "domicilios")
})

test_that("dicionario() filtra por coluna", {
  loc <- dicionario(coluna = "localidade")
  expect_true(all(loc$coluna == "localidade"))
  # 48 códigos na base de domicilios (anexo_1) + 1 linha sem código na
  # base de moradores (lacuna do dicionário oficial)
  loc_dom <- loc[loc$base == "domicilios", ]
  loc_mor <- loc[loc$base == "moradores", ]
  expect_equal(nrow(loc_dom), 48)
  expect_equal(nrow(loc_mor), 1)
  expect_true(is.na(loc_mor$valor))
  # expressão regular
  renda <- dicionario(coluna = "^renda_domiciliar")
  expect_gt(length(unique(renda$coluna)), 1)
})

test_that("metadados cobrem todas as colunas das bases", {
  dom <- data.table::fread(test_path("fixtures", "domicilios_mini.csv"),
                           sep = ";", encoding = "UTF-8")
  mor <- data.table::fread(test_path("fixtures", "moradores_mini.csv"),
                           sep = ";", encoding = "UTF-8")
  meta <- dicionario()
  expect_setequal(names(dom), unique(meta$coluna[meta$base == "domicilios"]))
  expect_setequal(names(mor), unique(meta$coluna[meta$base == "moradores"]))
})

test_that("anexos do dicionário foram expandidos", {
  meta <- dicionario()
  # localidade (anexo_1): Regiões Administrativas do DF, codificada na base
  # de domicilios; na base de moradores o dicionário a lista sem códigos
  loc <- meta[meta$coluna == "localidade" & meta$base == "domicilios", ]
  expect_true("5301" %in% loc$valor)
  expect_equal(loc$descricao_valor[loc$valor == "5301"], "Plano Piloto")
  expect_true(all(!is.na(loc$anexo)))
  # anexo_7 traz dois blocos completos (E19_1 e E20_1)
  e19 <- meta[meta$coluna == "E19_1", ]
  e20 <- meta[meta$coluna == "E20_1", ]
  expect_equal(nrow(e19), 5606)
  expect_equal(nrow(e20), 5654)
  expect_true("76110001" %in% e19$valor)
  # variáveis não codificadas ficam com valor NA
  expect_true("starttime" %in% meta$coluna[is.na(meta$valor)])
})
