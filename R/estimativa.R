utils::globalVariables(c(".x", ".w"))

#' Estimativas ponderadas a partir dos microdados da PDAD-A 2024
#'
#' Calcula médias, totais e proporções ponderadas pelos pesos de expansão
#' da PDAD-A 2024 (\code{peso_dom} na base de domicílios; \code{peso_mor}
#' na de moradores), opcionalmente desagregadas por grupos (ex.: por
#' \code{localidade} ou \code{setor_distrito}).
#'
#' O peso é inferido a partir das colunas presentes: \code{peso_dom} na
#' ausência de \code{peso_mor} e \code{peso_mor} na ausência de
#' \code{peso_dom}; quando ambos existem (ex.: resultado de
#' \code{\link{juntar_bases}}), informe o argumento \code{peso}
#' explicitamente.
#'
#' Para rendas, prefira as variáveis com sufixo \code{"_r"}, que já vêm
#' corrigidas pela inflação (multiplicadas por \code{infla_ipcadf},
#' fator do IPCA-DF divulgado com os microdados). Atenção aos códigos
#' reservados (77777 = Recusa, 88888 = Não sabe, 99999 = Não se aplica),
#' presentes em diversas variáveis: use \code{\link{limpar_reservados}}
#' antes de estimar.
#'
#' @param dados data.frame ou tibble com microdados da PDAD-A 2024.
#' @param variavel nome da variável de interesse (length 1).
#' @param tipo "media" (média ponderada), "total" (soma ponderada) ou
#'   "proporcao" (participação ponderada de cada nível quando a variável é
#'   qualitativa, ou média ponderada quando é lógica ou 0/1).
#' @param por opcional: vetor com nomes de colunas para desagregar a
#'   estimativa (ex.: \code{c("localidade")}).
#' @param peso opcional: nome da coluna de pesos. Se omitido, usa
#'   \code{peso_dom} ou \code{peso_mor}, quando identificável.
#' @param na_rm lógico; quando \code{TRUE} (padrão), exclui observações
#'   com \code{NA} na variável de interesse.
#' @return Um `tibble`. Para \code{tipo = "media"} e \code{"total"}:
#'   colunas de \code{por}, \code{estimativa} e \code{n} (número de
#'   observações válidas, sem peso). Para \code{tipo = "proporcao"} com
#'   variável qualitativa: inclui também a coluna \code{nivel}.
#' @keywords PDAD estatística
#' @export
#' @examples
#' \dontrun{
#' dom <- get_pdad("domicilios")
#' # renda domiciliar média por RA (valores corrigidos pela inflação)
#' estimar(dom, "renda_domiciliar_r", tipo = "media", por = "localidade")
#'
#' # proporção ponderada de domicílios por situação (após rotular)
#' estimar(rotular(dom), "A01uf", tipo = "proporcao")
#' }
estimar <- function(dados, variavel, tipo = c("media", "total", "proporcao"),
                    por = NULL, peso = NULL, na_rm = TRUE) {
  tipo <- match.arg(tipo)
  variavel <- variavel[1]
  if (!variavel %in% names(dados)) {
    stop("Vari\u00e1vel '", variavel, "' n\u00e3o encontrada em `dados`",
         call. = FALSE)
  }

  nms <- names(dados)
  if (is.null(peso)) {
    if ("peso_dom" %in% nms && !("peso_mor" %in% nms)) {
      peso <- "peso_dom"
    } else if ("peso_mor" %in% nms && !("peso_dom" %in% nms)) {
      peso <- "peso_mor"
    } else {
      stop("N\u00e3o foi poss\u00edvel inferir a coluna de pesos; informe `peso`",
           call. = FALSE)
    }
  } else {
    if (!peso %in% nms) {
      stop("Coluna de pesos '", peso, "' n\u00e3o encontrada em `dados`",
           call. = FALSE)
    }
  }

  if (!is.null(por) && !all(por %in% nms)) {
    stop("Coluna(s) de grupo ausente(s): ",
         paste(setdiff(por, nms), collapse = ", "), call. = FALSE)
  }

  dt <- data.table::as.data.table(dados)
  if (na_rm) dt <- dt[!is.na(dt[[variavel]])]
  dt$.w <- as.numeric(dt[[peso]])

  if (tipo %in% c("media", "total")) {
    dt$.x <- suppressWarnings(as.numeric(dt[[variavel]]))
    if (tipo == "media") {
      calc <- dt[, list(estimativa = sum(.x * .w, na.rm = na_rm) /
                          sum(.w[!is.na(.x)], na.rm = TRUE), n = .N),
                 by = por]
    } else {
      calc <- dt[, list(estimativa = sum(.x * .w, na.rm = na_rm), n = .N),
                 by = por]
    }
  } else {
    x <- dt[[variavel]]
    if (is.numeric(x) || is.logical(x)) {
      dt$.x <- suppressWarnings(as.numeric(x))
      calc <- dt[, list(estimativa = sum(.x * .w, na.rm = na_rm) /
                          sum(.w, na.rm = TRUE), n = .N),
                 by = por]
    } else {
      dt$nivel_pdadr <- as.character(x)
      nivel_col <- c(por, "nivel_pdadr")
      calc <- dt[, list(estimativa = sum(.w), n = .N), by = nivel_col]
      tot <- dt[, list(.tot = sum(.w)), by = por]
      if (is.null(por)) {
        calc$.tot <- sum(dt$.w)
      } else {
        calc <- merge(calc, tot, all.x = TRUE, by = por)
      }
      calc$estimativa <- calc$estimativa / calc$.tot
      calc$.tot <- NULL
      names(calc)[names(calc) == "nivel_pdadr"] <- "nivel"
    }
  }

  tibble::as_tibble(calc)
}

#' Remove códigos reservados dos microdados da PDAD-A 2024
#'
#' Substitui por \code{NA} os códigos reservados do questionário da
#' PDAD-A 2024 presentes em colunas numéricas: 77777 (Recusa), 88888 (Não
#' sabe) e 99999 (Não se aplica). Use antes de calcular estimativas com
#' \code{\link{estimar}}.
#'
#' @param dados data.frame ou tibble com microdados da PDAD-A 2024.
#' @param reservados códigos reservados a substituir.
#' @return Um `tibble` com os códigos reservados das colunas numéricas
#'   substituídos por \code{NA}.
#' @keywords PDAD limpeza
#' @export
#' @examples
#' d <- data.frame(renda = c(2000, 77777, 88888), peso_dom = c(1, 1, 1))
#' limpar_reservados(d)
limpar_reservados <- function(dados, reservados = c(77777, 88888, 99999)) {
  for (v in names(dados)) {
    if (is.numeric(dados[[v]])) {
      dados[[v]][dados[[v]] %in% reservados] <- NA_real_
    }
  }
  tibble::as_tibble(dados)
}
