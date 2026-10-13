# Consulta ao dicionário de variáveis da PDAD-A 2024

Retorna a tabela de metadados da PDAD-A 2024, opcionalmente filtrada por
base e por variáveis de interesse.

## Usage

``` r
dicionario(base = NULL, coluna = NULL)
```

## Arguments

- base:

  base de dados: "domicilios" ou "moradores". O padrão retorna as duas
  bases.

- coluna:

  opcional: nome(s) ou expressão regular das variáveis cujos metadados
  devem ser retornados.

## Value

Um \`tibble\` com as colunas `base`, `coluna`, `descricao_coluna`,
`valor`, `descricao_valor` e `anexo` (ver
[`?pdadmeta`](https://distintivelab.github.io/pdadr/reference/pdadmeta.md)).

## Examples

``` r
# metadados de uma variável codificada
dicionario(coluna = "localidade")
#> # A tibble: 49 × 6
#>    base       coluna     descricao_coluna            valor descricao_valor anexo
#>    <fct>      <chr>      <chr>                       <chr> <chr>           <chr>
#>  1 domicilios localidade Região Administrativa (DF)… 5301  Plano Piloto    anex…
#>  2 domicilios localidade Região Administrativa (DF)… 5302  Gama            anex…
#>  3 domicilios localidade Região Administrativa (DF)… 5303  Taguatinga      anex…
#>  4 domicilios localidade Região Administrativa (DF)… 5304  Brazlândia      anex…
#>  5 domicilios localidade Região Administrativa (DF)… 5305  Sobradinho      anex…
#>  6 domicilios localidade Região Administrativa (DF)… 5306  Planaltina      anex…
#>  7 domicilios localidade Região Administrativa (DF)… 5307  Paranoá         anex…
#>  8 domicilios localidade Região Administrativa (DF)… 5308  Núcleo Bandeir… anex…
#>  9 domicilios localidade Região Administrativa (DF)… 5309  Ceilândia       anex…
#> 10 domicilios localidade Região Administrativa (DF)… 5310  Guará           anex…
#> # ℹ 39 more rows

# todas as variáveis da base de moradores
# \donttest{
d <- dicionario(base = "moradores")
# }

# busca por expressão regular
dicionario(coluna = "^peso|^renda_domiciliar")
#> # A tibble: 6 × 6
#>   base       coluna                descricao_coluna  valor descricao_valor anexo
#>   <fct>      <chr>                 <chr>             <chr> <chr>           <chr>
#> 1 domicilios renda_domiciliar      Soma dos rendime… NA    NA              NA   
#> 2 domicilios renda_domiciliar_r    Soma dos rendime… NA    NA              NA   
#> 3 domicilios renda_domiciliar_pc   Renda domiciliar… NA    NA              NA   
#> 4 domicilios renda_domiciliar_pc_r Renda domiciliar… NA    NA              NA   
#> 5 domicilios peso_dom              Peso do domicílio NA    NA              NA   
#> 6 moradores  peso_mor              Peso do morador   NA    NA              NA   
```
