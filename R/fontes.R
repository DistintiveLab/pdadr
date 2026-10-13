#' Fontes oficiais dos arquivos da PDAD-A 2024
#'
#' Retorna os endereços dos arquivos divulgados pelo IPE/DF
#' (<https://pdad.ipe.df.gov.br/>) utilizados pelo pacote: as bases de
#' microdados, o dicionário de variáveis e o questionário da pesquisa.
#'
#' @return Um `tibble` com as colunas \code{arquivo}, \code{url} e
#'   \code{tipo}.
#' @keywords PDAD fontes
#' @export
#' @examples
#' fontes()
fontes <- function() {
  tibble::tibble(
    arquivo = names(.pdad_urls),
    url = unlist(.pdad_urls, use.names = FALSE),
    tipo = c("microdados", "microdados", "dicionario", "questionario")
  )
}
