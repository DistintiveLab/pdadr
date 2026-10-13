# Fontes oficiais dos arquivos da PDAD-A 2024

Retorna os endereços dos arquivos divulgados pelo IPE/DF
(\<https://pdad.ipe.df.gov.br/\>) utilizados pelo pacote: as bases de
microdados, o dicionário de variáveis e o questionário da pesquisa.

## Usage

``` r
fontes()
```

## Value

Um \`tibble\` com as colunas `arquivo`, `url` e `tipo`.

## Examples

``` r
fontes()
#> # A tibble: 4 × 3
#>   arquivo      url                                                         tipo 
#>   <chr>        <chr>                                                       <chr>
#> 1 domicilios   https://pdad.ipe.df.gov.br/files/reports/domicilios_QrV9v7… micr…
#> 2 moradores    https://pdad.ipe.df.gov.br/files/reports/moradores_60wwMwo… micr…
#> 3 dicionario   https://pdad.ipe.df.gov.br/files/reports/dicionario_de_var… dici…
#> 4 questionario https://pdad.ipe.df.gov.br/files/reports/Questionario_PDAD… ques…
```
