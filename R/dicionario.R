#' Consulta ao dicionário de variáveis da PDAD-A 2024
#'
#' Retorna a tabela de metadados da PDAD-A 2024, opcionalmente filtrada
#' por base e por variáveis de interesse.
#'
#' @param base base de dados: "domicilios" ou "moradores". O padrão
#'   retorna as duas bases.
#' @param coluna opcional: nome(s) ou expressão regular das variáveis
#'   cujos metadados devem ser retornados.
#' @return Um `tibble` com as colunas \code{base}, \code{coluna},
#'   \code{descricao_coluna}, \code{valor}, \code{descricao_valor} e
#'   \code{anexo} (ver \code{?pdadmeta}).
#' @keywords metadados dicionário
#' @export
#' @examples
#' # metadados de uma variável codificada
#' dicionario(coluna = "localidade")
#'
#' # todas as variáveis da base de moradores
#' d <- dicionario(base = "moradores")
#'
#' # busca por expressão regular
#' dicionario(coluna = "^peso|^renda_domiciliar")
dicionario <- function(base = NULL, coluna = NULL) {
  tab <- tibble::as_tibble(pdadr::pdadmeta)

  if (!is.null(base)) {
    base <- match.arg(tolower(base), .pdad_bases, several.ok = TRUE)
    tab <- tab[tab$base == base, ]
  }

  if (!is.null(coluna)) {
    tab <- tab[grepl(paste(coluna, collapse = "|"), tab$coluna), ]
  }

  tab
}
