#' @import data.table
#' @keywords internal
"_PACKAGE"

## URLs públicas dos arquivos divulgados pelo IPE/DF em
## https://pdad.ipe.df.gov.br/ . Os nomes dos arquivos carregam um sufixo
## aleatório definido pelo gerenciador de arquivos do site; conferir e
## atualizar aqui quando uma nova divulgação for publicada.
.pdad_urls <- list(
  domicilios = "https://pdad.ipe.df.gov.br/files/reports/domicilios_QrV9v7y.zip",
  moradores = "https://pdad.ipe.df.gov.br/files/reports/moradores_60wwMwo.zip",
  dicionario = "https://pdad.ipe.df.gov.br/files/reports/dicionario_de_variaveis_pdada_2024_p%C3%BAblico.xlsx",
  questionario = "https://pdad.ipe.df.gov.br/files/reports/Questionario_PDAD_A_2024_publico_RblethQ.pdf"
)

.pdad_bases <- c("domicilios", "moradores")
