#' Tabela de localidades da PDAD-A 2024
#'
#' Correspondência entre os 48 territórios da amostra da PDAD-A 2024 (36
#' Regiões Administrativas do DF e 12 municípios goianos do entorno) e os
#' códigos do IBGE, permitindo a harmonização com shapefiles do Censo e com
#' o pacote \pkg{geobr}.
#'
#' @format data.frame com 48 linhas e 7 colunas:
#' \describe{
#'   \item{valor}{código da variável \code{localidade} nos microdados
#'   (5301 a 5336 para RAs do DF; 5241 a 5252 para municípios de GO)}
#'   \item{nome}{nome do território conforme o dicionário da PDAD-A 2024}
#'   \item{uf}{unidade da federação: "DF" ou "GO"}
#'   \item{tipo}{"regiao_administrativa" (DF) ou "municipio" (GO)}
#'   \item{cod_ibge_municipio}{código IBGE de 7 dígitos do município. Para
#'   o DF, todas as RAs pertencem ao município 5300108 (Brasília)}
#'   \item{cod_ibge_subdistrito}{código IBGE de 11 dígitos do subdistrito
#'   do Censo 2022, que no DF corresponde às Regiões Administrativas;
#'   \code{NA} para municípios de GO e para as localidades criadas após o
#'   Censo 2022 (Arapoanga, Água Quente e Área Rural)}
#'   \item{nome_ibge}{nome oficial do território no IBGE, incluído para
#'   conferência quando difere do nome usado pela PDAD (ex.: "Sudoeste
#'   e Octogonal" na PDAD e "Sudoeste/Octogonal" no IBGE)}
#' }
#' @keywords territorial harmonização
#' @source Códigos de subdistrito extraídos dos setores censitários do
#' Censo 2022 (\code{geobr::read_census_tract(5300108, year = 2022)});
#' códigos de municípios goianos da API de localidades do IBGE. O script de
#' geração está em \code{data-raw/localidades.R}.
#' @examples
#' data(pdad_localidades)
#' head(pdad_localidades)
"pdad_localidades"

#' Tabela de setores da PDAD-A 2024
#'
#' Correspondência entre os 58 setores da variável \code{setor_distrito}
#' (subdivisões das Regiões Administrativas e dos municípios da amostra,
#' conforme coleta da PDAD-A 2024) e as localidades a que pertencem.
#'
#' @format data.frame com 58 linhas e 3 colunas:
#' \describe{
#'   \item{valor}{código da variável \code{setor_distrito} nos microdados
#'   ("1" a "58")}
#'   \item{descricao}{rótulo do setor no dicionário da PDAD-A 2024
#'   (ex.: "Plano Piloto - Área 1")}
#'   \item{localidade}{código da localidade (\code{valor} em
#'   \code{\link{pdad_localidades}}) a que o setor pertence}
#' }
#' @keywords territorial harmonização
#' @source Derivada da tabela \code{pdadmeta} (dicionário público da
#' PDAD-A 2024). O script de geração está em
#' \code{data-raw/localidades.R}.
#' @examples
#' data(pdad_setores)
#' head(pdad_setores)
"pdad_setores"

#' Consulta às localidades da PDAD-A 2024
#'
#' Retorna a tabela de correspondência entre os territórios da amostra da
#' PDAD-A 2024 (Regiões Administrativas do DF e municípios goianos do
#' entorno) e os códigos do IBGE, opcionalmente filtrada por UF ou tipo de
#' território. Os códigos permitem harmonizar os microdados com shapefiles
#' do Censo e com o pacote \pkg{geobr} (ver exemplos e a vignette do
#' pacote).
#'
#' A variável \code{localidade} dos microdados é o código \code{valor}
#' desta tabela; para agregar resultados por município IBGE, use
#' \code{cod_ibge_municipio} (todas as RAs do DF pertencem a 5300108,
#' Brasília); para o nível mais fino equivalente às RAs no recorte do
#' IBGE, use \code{cod_ibge_subdistrito} (Censo 2022).
#'
#' @param uf opcional: "DF" ou "GO".
#' @param tipo opcional: "regiao_administrativa" ou "municipio".
#' @return Um `tibble` com as colunas descritas em
#'   \code{?pdad_localidades}.
#' @keywords territorial harmonização
#' @export
#' @examples
#' head(localidades())
#' localidades(uf = "GO")
#' sum(is.na(localidades()$cod_ibge_subdistrito))  # 15
#'
#' \dontrun{
#' # harmonização com geobr: RAs do DF a partir dos setores do Censo 2022
#' if (requireNamespace("geobr", quietly = TRUE)) {
#'   ct <- geobr::read_census_tract(5300108, year = 2022)
#'   ras <- stats::aggregate(
#'     ct["code_subdistrict"],
#'     by = list(cod_ibge_subdistrito = ct$code_subdistrict),
#'     FUN = function(x) x[1]
#'   )
#'   mapa <- merge(ras, localidades(), by = "cod_ibge_subdistrito")
#' }
#' }
localidades <- function(uf = NULL, tipo = NULL) {
  tab <- tibble::as_tibble(pdadr::pdad_localidades)

  if (!is.null(uf)) {
    uf <- match.arg(toupper(uf), c("DF", "GO"), several.ok = TRUE)
    tab <- tab[tab$uf %in% uf, ]
  }
  if (!is.null(tipo)) {
    tipo <- match.arg(tolower(tipo),
                      c("regiao_administrativa", "municipio"),
                      several.ok = TRUE)
    tab <- tab[tab$tipo %in% tipo, ]
  }

  tab
}

#' Consulta aos setores da PDAD-A 2024
#'
#' Retorna a tabela dos 58 setores da variável \code{setor_distrito} dos
#' microdados (subdivisões das Regiões Administrativas e dos municípios da
#' amostra), com a localidade a que cada setor pertence.
#'
#' @param localidade opcional: código(s) da variável \code{localidade}
#'   (ex.: \code{"5301"}) ou nome(s) de território (ex.: \code{"Ceilândia"},
#'   case-insensitive); quando informado, retorna apenas os setores das
#'   localidades correspondentes.
#' @return Um `tibble` com as colunas \code{valor} (código do setor),
#'   \code{descricao} (rótulo) e \code{localidade} (código da localidade;
#'   ver \code{\link{localidades}}).
#' @keywords territorial harmonização
#' @export
#' @examples
#' head(setores())
#' setores(localidade = "Sobradinho")   # por nome
#' setores(localidade = "5247")         # por código (Luziânia-GO)
setores <- function(localidade = NULL) {
  tab <- tibble::as_tibble(pdadr::pdad_setores)

  if (!is.null(localidade)) {
    if (all(grepl("^[0-9]+$", localidade))) {
      tab <- tab[tab$localidade %in% localidade, ]
    } else {
      locs <- pdadr::pdad_localidades
      alvo <- locs$valor[tolower(locs$nome) %in% tolower(localidade)]
      if (length(alvo) == 0) {
        stop("Localidade n\u00e3o encontrada: ",
             paste(localidade, collapse = ", "), call. = FALSE)
      }
      tab <- tab[tab$localidade %in% alvo, ]
    }
  }

  tab
}
