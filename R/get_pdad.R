#' Download e leitura dos microdados da PDAD-A 2024
#'
#' Baixa (com cache local) e lê as bases de microdados da PDAD-A 2024
#' divulgadas pelo IPE/DF em <https://pdad.ipe.df.gov.br/>. Os arquivos
#' originais são compactados (zip) e os CSVs internos usam separador
#' ponto e vírgula e codificação UTF-8.
#'
#' @param base base(s) de dados: "domicilios" e/ou "moradores".
#' @param rotular lógico; quando \code{TRUE}, converte as variáveis
#'   codificadas para \code{factor} com rótulos do dicionário
#'   (ver \code{\link{rotular}}).
#' @param dir_cache diretório de cache para os arquivos baixados. O
#'   padrão usa \code{tools::R_user_dir("pdadr", "cache")}, de modo que o
#'   download ocorre uma única vez por máquina.
#' @param forcar lógico; quando \code{TRUE}, refaz o download mesmo que o
#'   arquivo já esteja em cache.
#' @return Quando uma única base é solicitada, um `tibble` com os
#'   microdados. Quando as duas bases são solicitadas, uma lista nomeada
#'   com os tibbles de "domicilios" e "moradores".
#' @keywords PDAD microdados
#' @export
#' @examples
#' \dontrun{
#' dom <- get_pdad("domicilios")
#' dados <- get_pdad(c("domicilios", "moradores"), rotular = TRUE)
#' }
get_pdad <- function(base = "domicilios", rotular = FALSE,
                     dir_cache = tools::R_user_dir("pdadr", "cache"),
                     forcar = FALSE) {
  base <- match.arg(tolower(base), .pdad_bases, several.ok = TRUE)

  if (!dir.exists(dir_cache)) dir.create(dir_cache, recursive = TRUE)

  ler <- function(b) {
    arq_csv <- file.path(dir_cache, paste0("pdada_2024_", b, ".csv"))
    if (forcar || !file.exists(arq_csv)) {
      arq_zip <- file.path(dir_cache, paste0(b, ".zip"))
      # zips de ~6 MB: garante timeout generoso (sem reduzir o do usuário)
      lim <- options(timeout = max(600, getOption("timeout")))
      on.exit(options(lim), add = TRUE)
      utils::download.file(.pdad_urls[[b]], arq_zip, mode = "wb", quiet = TRUE)
      csv_interno <- utils::unzip(arq_zip, list = TRUE)$Name
      dest <- tempfile()
      utils::unzip(arq_zip, files = csv_interno, exdir = dest)
      # file.copy (e não file.rename): o diretório temporário pode estar
      # em outro sistema de arquivos que o cache
      file.copy(file.path(dest, csv_interno), arq_csv, overwrite = TRUE)
    }
    dados <- data.table::fread(arq_csv, sep = ";", encoding = "UTF-8",
                               showProgress = FALSE, data.table = FALSE)
    dados <- .pdad_dec_virgula(dados)
    if (rotular) dados <- rotular(dados, base = b)
    tibble::as_tibble(dados)
  }

  resultado <- stats::setNames(lapply(base, ler), base)
  if (length(resultado) == 1) resultado[[1]] else resultado
}

# Os arquivos divulgados misturam separadores decimais: parte das colunas
# numéricas usa vírgula (formato brasileiro; ex.: peso_dom, peso_mor,
# infla_ipcadf e todas as rendas deflacionadas, sufixo "_r"). O fread
# então as traz como character. Esta função converte de volta para
# numeric apenas as colunas character cujos valores são todos decimais
# com vírgula (ou vazios), preservando as demais.
.pdad_dec_virgula <- function(dados) {
  chr <- names(dados)[vapply(dados, is.character, logical(1))]
  for (v in chr) {
    valores <- trimws(dados[[v]])
    valores <- valores[valores != "" & !is.na(valores)]
    if (length(valores) > 0 &&
        all(grepl("^-?[0-9]+([.,][0-9]+)?$", valores)) &&
        any(grepl(",", valores))) {
      dados[[v]] <- suppressWarnings(
        as.numeric(gsub(",", ".", dados[[v]])))
    }
  }
  dados
}
