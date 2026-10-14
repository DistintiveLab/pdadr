
#' Cruza as bases de domicílios e moradores da PDAD-A 2024
#'
#' Combina as bases de domicílios e moradores pela chave do domicílio
#' (\code{A01nficha}). Colunas presentes nas duas bases recebem sufixos
#' \code{"_dom"} e \code{"_mor"} (ex.: \code{localidade_dom} e
#' \code{localidade_mor}), com exceção da própria chave.
#'
#' Como o resultado contém os dois pesos (\code{peso_dom} e
#' \code{peso_mor}), informe explicitamente o argumento \code{peso} ao
#' usar \code{\link{estimar}}, ou \code{base} ao usar
#' \code{\link{design_pdad}}.
#'
#' @param domicilios data.frame ou tibble da base de domicílios (saída de
#'   \code{\link{get_pdad}}).
#' @param moradores data.frame ou tibble da base de moradores (saída de
#'   \code{\link{get_pdad}}).
#' @param como "moradores" (padrão): mantém todas as linhas de moradores,
#'   agregando as colunas do domicílio; "completo": mantém também
#'   domicílios sem moradores na amostra de moradores.
#' @return Um `tibble` resultante do cruzamento pela coluna
#'   \code{A01nficha}.
#' @keywords PDAD microdados
#' @export
#' @examples
#' \dontrun{
#' bases <- get_pdad(c("domicilios", "moradores"))
#' dados <- juntar_bases(bases$domicilios, bases$moradores)
#' # estimar por morador exige informar o peso:
#' # estimar(dados, "renda_total_r", tipo = "media", peso = "peso_mor")
#' }
juntar_bases <- function(domicilios, moradores,
                         como = c("moradores", "completo")) {
  como <- match.arg(como)

  if (!"A01nficha" %in% names(domicilios) ||
      !"A01nficha" %in% names(moradores)) {
    stop("A coluna 'A01nficha' \u00e9 obrigat\u00f3ria nas duas bases",
         call. = FALSE)
  }

  dt <- data.table::as.data.table(domicilios)
  dm <- data.table::as.data.table(moradores)
  chaves_iguais <- function(x) length(unique(x)) == length(x)
  if (!chaves_iguais(dt$A01nficha)) {
    stop("Base de domic\u00edlios tem chaves 'A01nficha' duplicadas",
         call. = FALSE)
  }

  res <- merge(dm, dt, by = "A01nficha",
               all = (como == "completo"),
               suffixes = c("_mor", "_dom"))

  tibble::as_tibble(res)
}
