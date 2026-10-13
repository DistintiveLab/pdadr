# localidades() e setores(): tabelas de harmonização territorial

test_that("localidades() retorna as 48 localidades com colunas esperadas", {
  loc <- localidades()
  expect_s3_class(loc, "tbl_df")
  expect_identical(nrow(loc), 48L)
  expect_named(loc, c("valor", "nome", "uf", "tipo", "cod_ibge_municipio",
                      "cod_ibge_subdistrito", "nome_ibge"))
})

test_that("localidades() filtra por uf e tipo", {
  expect_identical(nrow(localidades(uf = "DF")), 36L)
  expect_identical(nrow(localidades(uf = "GO")), 12L)
  expect_identical(nrow(localidades(tipo = "municipio")), 12L)
  expect_identical(nrow(localidades(tipo = "regiao_administrativa")), 36L)
  expect_identical(nrow(localidades(uf = "GO", tipo = "municipio")), 12L)
  expect_identical(nrow(localidades(uf = "GO", tipo = "regiao_administrativa")), 0L)
  expect_error(localidades(uf = "SP"), "arg")
})

test_that("códigos IBGE têm formatos e valores corretos", {
  loc <- localidades()
  expect_true(all(nchar(loc$cod_ibge_municipio) == 7))
  expect_true(all(nchar(loc$cod_ibge_subdistrito[!is.na(loc$cod_ibge_subdistrito)]) == 11))
  # DF inteiro pertence ao município de Brasília
  expect_true(all(loc$cod_ibge_municipio[loc$uf == "DF"] == "5300108"))
  # apenas GO + Arapoanga, Água Quente e Área Rural ficam sem subdistrito
  sem_sub <- is.na(loc$cod_ibge_subdistrito)
  expect_identical(sort(loc$valor[sem_sub]),
                   sort(c(localidades(uf = "GO")$valor, "5334", "5335", "5336")))
  # valores-conferência do cruzamento com o Censo 2022
  conf <- setNames(loc$cod_ibge_subdistrito, loc$valor)
  expect_identical(unname(conf["5301"]), "53001080506")
  expect_identical(unname(conf["5309"]), "53001080515")
  expect_identical(unname(conf["5333"]), "53001080532")
  # municípios goianos conferidos na API do IBGE
  go <- setNames(loc$cod_ibge_municipio[loc$uf == "GO"],
                 loc$valor[loc$uf == "GO"])
  expect_identical(unname(go["5247"]), "5212501")
  expect_identical(unname(go["5250"]), "5217609")
})

test_that("localidades() cobre exatamente os códigos do dicionário", {
  dic <- dicionario(coluna = "^localidade$", base = "domicilios")
  expect_setequal(localidades()$valor, dic$valor)
})

test_that("setores() retorna os 58 setores e vincula localidades válidas", {
  st <- setores()
  expect_s3_class(st, "tbl_df")
  expect_identical(nrow(st), 58L)
  expect_named(st, c("valor", "descricao", "localidade"))
  expect_true(all(st$localidade %in% localidades()$valor))
  # todas as localidades têm ao menos um setor
  expect_setequal(unique(st$localidade), localidades()$valor)
})

test_that("setores() filtra por código e por nome de localidade", {
  sob <- setores(localidade = "5305")
  expect_identical(sob$valor, "8")
  # nome "Sobradinho" não traz Sobradinho II
  expect_identical(nrow(setores(localidade = "Sobradinho")), 1L)
  expect_identical(nrow(setores(localidade = "Sobradinho II")), 1L)
  expect_identical(nrow(setores(localidade = c("Luziânia", "Novo Gama"))), 3L)
  expect_error(setores(localidade = "Xyzópolis"), "n\u00e3o encontrada")
})

test_that("setores(): conferências pontuais do mapeamento", {
  st <- setores()
  m <- setNames(st$localidade, st$valor)
  expect_identical(unname(m["17"]), "5314")  # São Sebastião - Área 1
  expect_identical(unname(m["29"]), "5325")  # SCIA - Área 1
  expect_identical(unname(m["40"]), "5334")  # Arapoanga
  expect_identical(unname(m["42"]), "5336")  # Área rural
  expect_identical(unname(m["43"]), "5241")  # Águas Lindas -> município GO
  expect_identical(unname(m["47"]), "5250")  # Planaltina de Goiás
  expect_identical(unname(m["58"]), "5251")  # Sto Antônio do Descoberto
})
