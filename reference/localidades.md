# Consulta às localidades da PDAD-A 2024

Retorna a tabela de correspondência entre os territórios da amostra da
PDAD-A 2024 (Regiões Administrativas do DF e municípios goianos do
entorno) e os códigos do IBGE, opcionalmente filtrada por UF ou tipo de
território. Os códigos permitem harmonizar os microdados com shapefiles
do Censo e com o pacote geobr (ver exemplos e a vignette do pacote).

## Usage

``` r
localidades(uf = NULL, tipo = NULL)
```

## Arguments

- uf:

  opcional: "DF" ou "GO".

- tipo:

  opcional: "regiao_administrativa" ou "municipio".

## Value

Um \`tibble\` com as colunas descritas em
[`?pdad_localidades`](https://distintivelab.github.io/pdadr/reference/pdad_localidades.md).

## Details

A variável `localidade` dos microdados é o código `valor` desta tabela;
para agregar resultados por município IBGE, use `cod_ibge_municipio`
(todas as RAs do DF pertencem a 5300108, Brasília); para o nível mais
fino equivalente às RAs no recorte do IBGE, use `cod_ibge_subdistrito`
(Censo 2022).

## Examples

``` r
head(localidades())
#> # A tibble: 6 × 7
#>   valor nome       uf    tipo  cod_ibge_municipio cod_ibge_subdistrito nome_ibge
#>   <chr> <chr>      <chr> <chr> <chr>              <chr>                <chr>    
#> 1 5301  Plano Pil… DF    regi… 5300108            53001080506          Plano Pi…
#> 2 5302  Gama       DF    regi… 5300108            53001080507          Gama     
#> 3 5303  Taguatinga DF    regi… 5300108            53001080508          Taguatin…
#> 4 5304  Brazlândia DF    regi… 5300108            53001080509          Brazlând…
#> 5 5305  Sobradinho DF    regi… 5300108            53001080510          Sobradin…
#> 6 5306  Planaltina DF    regi… 5300108            53001080511          Planalti…
localidades(uf = "GO")
#> # A tibble: 12 × 7
#>    valor nome      uf    tipo  cod_ibge_municipio cod_ibge_subdistrito nome_ibge
#>    <chr> <chr>     <chr> <chr> <chr>              <chr>                <chr>    
#>  1 5241  Águas Li… GO    muni… 5200258            NA                   Águas Li…
#>  2 5242  Alexânia  GO    muni… 5200308            NA                   Alexânia 
#>  3 5243  Cidade O… GO    muni… 5205497            NA                   Cidade O…
#>  4 5244  Cristali… GO    muni… 5206206            NA                   Cristali…
#>  5 5245  Cocalzin… GO    muni… 5205513            NA                   Cocalzin…
#>  6 5246  Formosa   GO    muni… 5208004            NA                   Formosa  
#>  7 5247  Luziânia  GO    muni… 5212501            NA                   Luziânia 
#>  8 5248  Novo Gama GO    muni… 5215231            NA                   Novo Gama
#>  9 5249  Padre Be… GO    muni… 5215603            NA                   Padre Be…
#> 10 5250  Planalti… GO    muni… 5217609            NA                   Planalti…
#> 11 5251  Santo An… GO    muni… 5219753            NA                   Santo An…
#> 12 5252  Valparaí… GO    muni… 5221858            NA                   Valparaí…
sum(is.na(localidades()$cod_ibge_subdistrito))  # 15
#> [1] 15

# \donttest{
# harmonização com geobr: RAs do DF a partir dos setores do Censo 2022
if (requireNamespace("geobr", quietly = TRUE)) {
  ct <- geobr::read_census_tract(5300108, year = 2022)
  ras <- stats::aggregate(
    ct["code_subdistrict"],
    by = list(cod_ibge_subdistrito = ct$code_subdistrict),
    FUN = function(x) x[1]
  )
  mapa <- merge(ras, localidades(), by = "cod_ibge_subdistrito")
}
#> ℹ Using year/date 2022
#> duckdb keeps downloaded extensions and secrets in a temporary directory:
#> ℹ /tmp/RtmpzN47nC/duckdb
#> This is removed when the R session ends.
#> • Extensions are re-downloaded each session.
#> • Secrets are lost.
#> ℹ Run duckdb(shared_home = TRUE) (or create ~/.duckdb) to keep them (suitable for most users).
#> ℹ Run duckdb(shared_home = FALSE) to accept the temporary directory (and silence this message).
#> ℹ See ?duckdb_storage for details and alternatives.
# }
```
