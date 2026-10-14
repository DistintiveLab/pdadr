# Download e leitura dos microdados da PDAD-A 2024

Baixa (com cache local) e lê as bases de microdados da PDAD-A 2024
divulgadas pelo IPE/DF em \<https://pdad.ipe.df.gov.br/\>. Os arquivos
originais são compactados (zip) e os CSVs internos usam separador ponto
e vírgula e codificação UTF-8.

## Usage

``` r
get_pdad(
  base = "domicilios",
  rotular = FALSE,
  dir_cache = tools::R_user_dir("pdadr", "cache"),
  forcar = FALSE
)
```

## Arguments

- base:

  base(s) de dados: "domicilios" e/ou "moradores".

- rotular:

  lógico; quando `TRUE`, converte as variáveis codificadas para `factor`
  com rótulos do dicionário (ver
  [`rotular`](https://distintivelab.github.io/pdadr/reference/rotular.md)).

- dir_cache:

  diretório de cache para os arquivos baixados. O padrão usa
  `tools::R_user_dir("pdadr", "cache")`, de modo que o download ocorre
  uma única vez por máquina.

- forcar:

  lógico; quando `TRUE`, refaz o download mesmo que o arquivo já esteja
  em cache.

## Value

Quando uma única base é solicitada, um \`tibble\` com os microdados.
Quando as duas bases são solicitadas, uma lista nomeada com os tibbles
de "domicilios" e "moradores".

## Examples

``` r
if (FALSE) { # \dontrun{
dom <- get_pdad("domicilios")
dados <- get_pdad(c("domicilios", "moradores"), rotular = TRUE)
} # }
```
