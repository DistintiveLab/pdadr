#' Objeto de desenho amostral para a PDAD-A 2024
#'
#' Cria um objeto de desenho amostral (\pkg{survey}) a partir dos
#' microdados da PDAD-A 2024, usando os pesos de expansão. Útil para
#' replicar com \code{survey::svymean()}, \code{survey::svytotal()},
#' \code{survey::svyby()} etc. as estimativas pontuais de
#' \code{\link{estimar}}.
#'
#' O IPE/DF não divulga as unidades primárias de amostragem (UPAs) nem os
#' estratos da PDAD-A 2024, de modo que o desenho criado é apenas
#' ponderado (\code{ids = ~1}): erros-padrão produzidos por funções do
#' \pkg{survey} subestimam a variância amostral verdadeira e não devem ser
#' usados para inferência. As estimativas pontuais (médias, totais,
#' proporções) não são afetadas por essa limitação.
#'
#' @param dados data.frame ou tibble com microdados da PDAD-A 2024.
#' @param base opcional: "domicilios" ou "moradores". Quando omitido, é
#'   inferido das colunas de pesos presentes.
#' @param ids fórmula de identificação das UPAs, repassada a
#'   \code{survey::svydesign()}; o padrão \code{~1} indica desenho apenas
#'   ponderado.
#' @param ... outros argumentos repassados a \code{survey::svydesign()}
#'   (ex.: \code{strata}, \code{fpc}).
#' @return Um objeto de classe \code{survey.design} criado com os pesos
#'   da base informada.
#' @keywords PDAD amostragem survey
#' @export
#' @examples
#' \donttest{
#' desenho <- design_pdad(get_pdad("domicilios"))
#' # survey::svymean(~renda_domiciliar_r, desenho)
#' }
design_pdad <- function(dados, base = NULL, ids = NULL, ...) {
  if (!requireNamespace("survey", quietly = TRUE)) {
    stop("Pacote 'survey' n\u00e3o instalado; instale com ",
         "install.packages(\"survey\")", call. = FALSE)
  }

  if (is.null(base)) {
    nms <- names(dados)
    if ("peso_dom" %in% nms && !("peso_mor" %in% nms)) {
      base <- "domicilios"
    } else if ("peso_mor" %in% nms && !("peso_dom" %in% nms)) {
      base <- "moradores"
    } else {
      stop("N\u00e3o foi poss\u00edvel inferir a base a partir das colunas ",
           "(as duas colunas de peso est\u00e3o presentes?); informe `base`",
           call. = FALSE)
    }
  }
  base <- match.arg(tolower(base), .pdad_bases)

  peso <- if (base == "domicilios") "peso_dom" else "peso_mor"
  if (!peso %in% names(dados)) {
    stop("Coluna de pesos '", peso, "' n\u00e3o encontrada em `dados`",
         call. = FALSE)
  }
  if (is.null(ids)) ids <- ~1

  survey::svydesign(ids = ids,
                    weights = stats::as.formula(paste0("~", peso)),
                    data = dados, ...)
}
