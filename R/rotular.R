#' Rotula variáveis codificadas da PDAD-A 2024
#'
#' Converte as variáveis codificadas de um data.frame de microdados da
#' PDAD-A 2024 em \code{factor}, atribuindo os rótulos do dicionário de
#' variáveis. Variáveis cujos valores observados não estejam integralmente
#' cobertos pelo dicionário são mantidas inalteradas.
#'
#' A base é inferida automaticamente a partir das colunas presentes
#' (\code{peso_dom} indica domicílios; \code{peso_mor} indica moradores),
#' mas pode ser informada explicitamente.
#'
#' @param dados data.frame ou tibble com microdados da PDAD-A 2024.
#' @param base opcional: "domicilios" ou "moradores".
#' @return Um `tibble` com as mesmas colunas de \code{dados}, tendo as
#'   variáveis codificadas convertidas para \code{factor}.
#' @keywords PDAD metadados
#' @export
#' @examples
#' \dontrun{
#' dom <- get_pdad("domicilios")
#' dom_rot <- rotular(dom)
#' table(dom_rot$localidade)
#' }
rotular <- function(dados, base = NULL) {
  if (is.null(base)) {
    nms <- names(dados)
    if ("peso_dom" %in% nms && !("peso_mor" %in% nms)) {
      base <- "domicilios"
    } else if ("peso_mor" %in% nms) {
      base <- "moradores"
    } else {
      stop("N\u00e3o foi poss\u00edvel inferir a base a partir das colunas; informe `base`",
           call. = FALSE)
    }
  }
  base <- match.arg(tolower(base), .pdad_bases)

  meta_df <- pdadr::pdadmeta
  meta <- meta_df[meta_df$base == base & !is.na(meta_df$valor), ]

  for (var in unique(meta$coluna[meta$coluna %in% names(dados)])) {
    codigos <- meta$valor[meta$coluna == var]
    rotulos <- meta$descricao_valor[meta$coluna == var]
    observados <- unique(as.character(stats::na.omit(dados[[var]])))
    if (all(observados %in% codigos)) {
      dados[[var]] <- factor(as.character(dados[[var]]),
                             levels = codigos, labels = rotulos)
    }
  }

  tibble::as_tibble(dados)
}
