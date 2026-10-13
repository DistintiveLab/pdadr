test_that("colunas decimais com vírgula são convertidas para numeric", {
  # os arquivos divulgados misturam '.' e ',' como separador decimal
  df <- data.frame(
    peso_dom = c("123,45", "67,89"),
    renda_r = c("1234,56", "-7,5"),
    texto = c("abc", NA_character_),
    vazio = c("", ""),
    inteiro = c("1", "2"),
    stringsAsFactors = FALSE
  )
  res <- pdadr:::.pdad_dec_virgula(df)
  expect_type(res$peso_dom, "double")
  expect_equal(res$peso_dom, c(123.45, 67.89))
  expect_equal(res$renda_r, c(1234.56, -7.5))
  expect_type(res$texto, "character")
  expect_type(res$vazio, "character")
  expect_type(res$inteiro, "character")
})

test_that("get_pdad() devolve pesos numéricos", {
  dir_cache <- file.path(tempdir(), "pdadr-cache4")
  dir.create(dir_cache)
  # fixture com vírgula decimal no peso, como no arquivo oficial
  linhas <- readLines(test_path("fixtures", "domicilios_mini.csv"))
  cab <- strsplit(linhas[1], ";")[[1]]
  i <- match("peso_dom", cab)
  partes <- strsplit(linhas[-1], ";", fixed = TRUE)
  for (p in partes) p[i] <- sub(".", ",", p[i], fixed = TRUE)
  linhas[-1] <- vapply(partes, paste, character(1), collapse = ";")
  writeLines(linhas, file.path(dir_cache, "pdada_2024_domicilios.csv"))

  dom <- get_pdad("domicilios", dir_cache = dir_cache)
  expect_type(dom$peso_dom, "double")
})
