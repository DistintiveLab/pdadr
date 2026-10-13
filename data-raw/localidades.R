# Script para gerar as tabelas territoriais `pdad_localidades` e
# `pdad_setores` (correspondência PDAD-A 2024 <-> IBGE/geobr).
#
# Fontes:
# - Nomes e códigos PDAD: anexo_1 da tabela `pdadmeta` (dicionário público
#   da PDAD-A 2024, IPE/DF), variáveis `localidade` (48 valores) e
#   `setor_distrito` (58 valores).
# - Códigos IBGE de municípios goianos: API de localidades do IBGE
#   (https://servicodados.ibge.gov.br/api/v1/localidades/estados/52/municipios),
#   verificados manualmente.
# - Códigos IBGE de subdistritos do DF (Censo 2022): extraídos de
#   geobr::read_census_tract(5300108, year = 2022), campo
#   `code_subdistrict`/`name_subdistrict` (33 subdistritos; os nomes dos
#   subdistritos do DF correspondem às Regiões Administrativas).
#
# Observações sobre a harmonização:
# - O IBGE trata o DF como um único município (5300108, Brasília) com um
#   único distrito (530010805); as RAs correspondem, no recorte do IBGE,
#   aos subdistritos do distrito de Brasília (Censo 2022).
# - As RAs Arapoanga (5334), Água Quente (5335) e Área Rural (5336) não
#   possuem subdistrito equivalente no Censo 2022 (as duas primeiras foram
#   criadas após o Censo; a última não é subdistrito IBGE) e ficam com
#   `cod_ibge_subdistrito` = NA.
#
# Executar manualmente quando uma nova edição da PDAD for publicada:
#   source("data-raw/localidades.R", encoding = "UTF-8")

load("data/pdadmeta.rda")

loc <- pdadmeta[pdadmeta$base == "domicilios" &
                  pdadmeta$coluna == "localidade",
                c("valor", "descricao_valor")]
setor <- pdadmeta[pdadmeta$base == "domicilios" &
                    pdadmeta$coluna == "setor_distrito",
                  c("valor", "descricao_valor")]

stopifnot(nrow(loc) == 48, nrow(setor) == 58)

## ------------------------------------------------------------------
## 1. Correspondências com o IBGE (códigos verificados manualmente)
## ------------------------------------------------------------------

# Subdistritos do DF no Censo 2022 (5300108 + distrito 05 + subdistrito XX)
subdistrito_df <- c(
  "5301" = "53001080506",  # Plano Piloto
  "5302" = "53001080507",  # Gama
  "5303" = "53001080508",  # Taguatinga
  "5304" = "53001080509",  # Brazlândia
  "5305" = "53001080510",  # Sobradinho
  "5306" = "53001080511",  # Planaltina
  "5307" = "53001080512",  # Paranoá
  "5308" = "53001080514",  # Núcleo Bandeirante
  "5309" = "53001080515",  # Ceilândia
  "5310" = "53001080516",  # Guará
  "5311" = "53001080517",  # Cruzeiro
  "5312" = "53001080518",  # Samambaia
  "5313" = "53001080525",  # Santa Maria
  "5314" = "53001080530",  # São Sebastião
  "5315" = "53001080520",  # Recanto das Emas
  "5316" = "53001080523",  # Lago Sul
  "5317" = "53001080513",  # Riacho Fundo
  "5318" = "53001080521",  # Lago Norte
  "5319" = "53001080519",  # Candangolândia
  "5320" = "53001080536",  # Águas Claras
  "5321" = "53001080541",  # Riacho Fundo II
  "5322" = "53001080535",  # Sudoeste/Octogonal
  "5323" = "53001080543",  # Varjão
  "5324" = "53001080542",  # Park Way
  "5325" = "53001080534",  # SCIA
  "5326" = "53001080544",  # Sobradinho II
  "5327" = "53001080540",  # Jardim Botânico
  "5328" = "53001080538",  # Itapoã
  "5329" = "53001080533",  # SIA
  "5330" = "53001080537",  # Vicente Pires
  "5331" = "53001080539",  # Fercal
  "5332" = "53001080531",  # Sol Nascente/Pôr do Sol
  "5333" = "53001080532"   # Arniqueira
)

# Nome oficial no IBGE (Censo 2022) quando difere do nome usado na PDAD;
# incluído para todos para facilitar a conferência com outras tabelas IBGE
nome_ibge_df <- c(
  "5301" = "Plano Piloto",         "5302" = "Gama",
  "5303" = "Taguatinga",           "5304" = "Brazlândia",
  "5305" = "Sobradinho",           "5306" = "Planaltina",
  "5307" = "Paranoá",              "5308" = "Núcleo Bandeirante",
  "5309" = "Ceilândia",            "5310" = "Guará",
  "5311" = "Cruzeiro",             "5312" = "Samambaia",
  "5313" = "Santa Maria",          "5314" = "São Sebastião",
  "5315" = "Recanto das Emas",     "5316" = "Lago Sul",
  "5317" = "Riacho Fundo",         "5318" = "Lago Norte",
  "5319" = "Candangolândia",       "5320" = "Águas Claras",
  "5321" = "Riacho Fundo II",      "5322" = "Sudoeste/Octogonal",
  "5323" = "Varjão",               "5324" = "Park Way",
  "5325" = "SCIA",                 "5326" = "Sobradinho II",
  "5327" = "Jardim Botânico",      "5328" = "Itapoã",
  "5329" = "SIA",                  "5330" = "Vicente Pires",
  "5331" = "Fercal",               "5332" = "Sol Nascente/Pôr do Sol",
  "5333" = "Arniqueira",           "5334" = NA,
  "5335" = NA,                     "5336" = NA
)

# Municípios goianas da amostra: código IBGE do município (API de
# localidades do IBGE) e nome oficial
mun_go <- c(
  "5241" = "5200258",  # Águas Lindas de Goiás
  "5242" = "5200308",  # Alexânia
  "5243" = "5205497",  # Cidade Ocidental
  "5244" = "5206206",  # Cristalina
  "5245" = "5205513",  # Cocalzinho de Goiás
  "5246" = "5208004",  # Formosa
  "5247" = "5212501",  # Luziânia
  "5248" = "5215231",  # Novo Gama
  "5249" = "5215603",  # Padre Bernardo
  "5250" = "5217609",  # Planaltina
  "5251" = "5219753",  # Santo Antônio do Descoberto
  "5252" = "5221858"   # Valparaíso de Goiás
)

nome_ibge_go <- c(
  "5241" = "Águas Lindas de Goiás", "5242" = "Alexânia",
  "5243" = "Cidade Ocidental",      "5244" = "Cristalina",
  "5245" = "Cocalzinho de Goiás",   "5246" = "Formosa",
  "5247" = "Luziânia",              "5248" = "Novo Gama",
  "5249" = "Padre Bernardo",        "5250" = "Planaltina",
  "5251" = "Santo Antônio do Descoberto", "5252" = "Valparaíso de Goiás"
)

# Verificações das correspondências hardcoded
stopifnot(
  all(names(subdistrito_df) %in% loc$valor),
  all(names(subdistrito_df) %in% names(nome_ibge_df)),
  all(substr(subdistrito_df, 1, 9) == "530010805"),
  all(names(mun_go) %in% loc$valor),
  nchar(mun_go) == 7
)

## ------------------------------------------------------------------
## 2. Tabela de localidades
## ------------------------------------------------------------------

pdad_localidades <- data.frame(
  valor = loc$valor,
  nome = loc$descricao_valor,
  uf = ifelse(as.integer(loc$valor) >= 5301, "DF", "GO"),
  stringsAsFactors = FALSE
)
pdad_localidades$tipo <- ifelse(pdad_localidades$uf == "DF",
                                "regiao_administrativa", "municipio")

pdad_localidades$cod_ibge_municipio <- ifelse(
  pdad_localidades$uf == "DF", "5300108",
  mun_go[pdad_localidades$valor])
pdad_localidades$cod_ibge_subdistrito <- unname(
  subdistrito_df[pdad_localidades$valor])
pdad_localidades$nome_ibge <- ifelse(
  pdad_localidades$uf == "DF",
  unname(nome_ibge_df[pdad_localidades$valor]),
  nome_ibge_go[pdad_localidades$valor])

stopifnot(
  nrow(pdad_localidades) == 48,
  sum(pdad_localidades$tipo == "regiao_administrativa") == 36,
  sum(pdad_localidades$tipo == "municipio") == 12,
  all(nchar(pdad_localidades$cod_ibge_municipio) == 7)
)

## ------------------------------------------------------------------
## 3. Tabela de setores (sub-áreas de RA / município)
##    A localidade de cada setor é derivada do próprio rótulo do setor,
##    com verificação automática (prefixo normalizado + match mais longo)
## ------------------------------------------------------------------

normalizar <- function(x) {
  x <- tolower(x)
  x <- gsub("[áàâãä]", "a", x)
  x <- gsub("[éèêë]", "e", x)
  x <- gsub("[íìîï]", "i", x)
  x <- gsub("[óòôõö]", "o", x)
  x <- gsub("[úùûü]", "u", x)
  x <- gsub("ç", "c", x)
  gsub("[^a-z0-9]", "", x)
}

loc_norm <- normalizar(pdad_localidades$nome)
names(loc_norm) <- pdad_localidades$valor

achar_localidade <- function(descricao) {
  d <- normalizar(descricao)
  # 1a passada: o setor é mais específico que a localidade (nome da
  # localidade é prefixo do rótulo do setor; ex.: "Sobradinho - Área 1")
  cand <- loc_norm[d == loc_norm | startsWith(d, loc_norm)]
  # 2a passada: a localidade é mais específica (casos de municípios GO;
  # ex.: setor "Águas Lindas" -> localidade "Águas Lindas de Goiás")
  if (length(cand) == 0) cand <- loc_norm[startsWith(loc_norm, d)]
  if (length(cand) == 0) return(NA_character_)
  # match mais longo desempata (ex.: "Sobradinho II" vs "Sobradinho")
  names(cand)[which.max(nchar(cand))]
}

setor_localidade <- vapply(setor$descricao_valor, achar_localidade,
                           character(1))
names(setor_localidade) <- NULL

if (any(is.na(setor_localidade))) {
  stop("Setores sem localidade correspondente: ",
       paste(setor$valor[is.na(setor_localidade)], collapse = ", "))
}
if (!setequal(setor_localidade, pdad_localidades$valor)) {
  stop("Localidades sem setor correspondente: ",
       paste(setdiff(pdad_localidades$valor, setor_localidade),
             collapse = ", "))
}

pdad_setores <- data.frame(
  valor = setor$valor,
  descricao = setor$descricao_valor,
  localidade = setor_localidade,
  stringsAsFactors = FALSE
)

# conferência manual dos casos com nome divergente entre PDAD e setor
stopifnot(
  pdad_setores$localidade[pdad_setores$valor == "40"] == "5334",  # Arapoanga
  pdad_setores$localidade[pdad_setores$valor == "42"] == "5336",  # Área rural
  pdad_setores$localidade[pdad_setores$valor == "43"] == "5241",  # Águas Lindas
  pdad_setores$localidade[pdad_setores$valor == "47"] == "5250",  # Planaltina GO
  pdad_setores$localidade[pdad_setores$valor == "58"] == "5251"   # Sto Ant. Descoberto
)

save(pdad_localidades, file = "data/pdad_localidades.rda",
     compress = "bzip2")
save(pdad_setores, file = "data/pdad_setores.rda", compress = "bzip2")

message("pdad_localidades: ", nrow(pdad_localidades), " linhas; ",
        "pdad_setores: ", nrow(pdad_setores), " linhas")
print(pdad_localidades[, c("valor", "nome", "uf",
                           "cod_ibge_subdistrito", "nome_ibge")],
      row.names = FALSE)
