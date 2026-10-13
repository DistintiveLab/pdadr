# Não-regressão contra as divulgações oficiais da PDAD-A 2024.
# Valores fixados a partir dos arquivos publicados pelo IPE/DF em
# https://pdad.ipe.df.gov.br/ (domicilios_QrV9v7y.zip e
# moradores_60wwMwo.zip). Se o IPE/DF republicar os arquivos com outro
# conteúdo, atualize as constantes e regenere pdadmeta.

test_that("dimensões das bases oficiais permanecem estáveis", {
  skip_on_cran()
  skip_if_offline("pdad.ipe.df.gov.br")

  dados <- get_pdad(c("domicilios", "moradores"))
  expect_equal(dim(dados$domicilios), c(24845, 128))
  expect_equal(dim(dados$moradores), c(69542, 134))
})

test_that("pesos de expansão somam a população esperada", {
  skip_on_cran()
  skip_if_offline("pdad.ipe.df.gov.br")

  dados <- get_pdad(c("domicilios", "moradores"))
  expect_equal(sum(dados$domicilios$peso_dom), 1806637.759085,
               tolerance = 1e-6)
  expect_equal(sum(dados$moradores$peso_mor), 4255723.771694,
               tolerance = 1e-6)
})
