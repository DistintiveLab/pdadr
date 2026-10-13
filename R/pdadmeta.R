#' Tabela de metadados da PDAD-A 2024
#'
#' Tabela de metadados completa das bases de microdados da PDAD-A 2024,
#' obtida a partir do dicionário de variáveis público do IPE/DF. Contém,
#' para cada variável das bases de domicílios e moradores, sua descrição
#' e, quando codificada, a lista de códigos e respectivos rótulos.
#'
#' @format data.frame com 19.496 linhas e 6 colunas:
#' \describe{
#'   \item{base}{base de origem: "domicilios" ou "moradores"}
#'   \item{coluna}{nome da variável, conforme cabeçalho dos arquivos CSV}
#'   \item{descricao_coluna}{descrição da variável no dicionário}
#'   \item{valor}{código observado na base; \code{NA} para variáveis não codificadas}
#'   \item{descricao_valor}{rótulo do código; \code{NA} para variáveis não codificadas}
#'   \item{anexo}{planilha do dicionário de onde os códigos foram extraídos
#'   ("anexo_1" a "anexo_11"); \code{NA} quando a codificação está na própria
#'   planilha da base}
#' }
#' @keywords metadados dicionário
#' @source Extraído de
#' \url{https://pdad.ipe.df.gov.br/files/reports/dicionario_de_variaveis_pdada_2024_p\%C3\%BAblico.xlsx}.
#' O script de geração está em \code{data-raw/pdadmeta.R}.
#' @examples
#' data(pdadmeta)
#' head(pdadmeta)
"pdadmeta"
