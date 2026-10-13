test_that("get_pdad() lê a base a partir do cache local", {
  dir_cache <- file.path(tempdir(), "pdadr-cache")
  dir.create(dir_cache)
  file.copy(test_path("fixtures", "domicilios_mini.csv"),
            file.path(dir_cache, "pdada_2024_domicilios.csv"))

  dom <- get_pdad("domicilios", dir_cache = dir_cache)
  expect_s3_class(dom, "tbl_df")
  expect_equal(ncol(dom), 128)
  expect_equal(names(dom)[1], "starttime")
})

test_that("get_pdad() retorna lista nomeada para duas bases", {
  dir_cache <- file.path(tempdir(), "pdadr-cache2")
  dir.create(dir_cache)
  file.copy(test_path("fixtures", "domicilios_mini.csv"),
            file.path(dir_cache, "pdada_2024_domicilios.csv"))
  file.copy(test_path("fixtures", "moradores_mini.csv"),
            file.path(dir_cache, "pdada_2024_moradores.csv"))

  dados <- get_pdad(c("domicilios", "moradores"), dir_cache = dir_cache)
  expect_type(dados, "list")
  expect_equal(names(dados), c("domicilios", "moradores"))
  expect_equal(ncol(dados$moradores), 134)
})

test_that("get_pdad() rotula quando solicitado", {
  dir_cache <- file.path(tempdir(), "pdadr-cache3")
  dir.create(dir_cache)
  file.copy(test_path("fixtures", "moradores_mini.csv"),
            file.path(dir_cache, "pdada_2024_moradores.csv"))

  mor <- get_pdad("moradores", rotular = TRUE, dir_cache = dir_cache)
  expect_s3_class(mor$A01uf, "factor")
  expect_false(any(c("52", "53") %in% as.character(mor$A01uf)))
})

test_that("get_pdad() rejeita base inválida", {
  expect_error(get_pdad("visitas"), "domicilios")
})
