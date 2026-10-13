test_that("fontes() lista os arquivos oficiais", {
  f <- fontes()
  expect_s3_class(f, "tbl_df")
  expect_setequal(f$arquivo, c("domicilios", "moradores", "dicionario", "questionario"))
  expect_true(all(grepl("^https://pdad\\.ipe\\.df\\.gov\\.br/", f$url)))
})
