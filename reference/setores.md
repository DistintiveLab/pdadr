# Consulta aos setores da PDAD-A 2024

Retorna a tabela dos 58 setores da variável `setor_distrito` dos
microdados (subdivisões das Regiões Administrativas e dos municípios da
amostra), com a localidade a que cada setor pertence.

## Usage

``` r
setores(localidade = NULL)
```

## Arguments

- localidade:

  opcional: código(s) da variável `localidade` (ex.: `"5301"`) ou
  nome(s) de território (ex.: `"Ceilândia"`, case-insensitive); quando
  informado, retorna apenas os setores das localidades correspondentes.

## Value

Um \`tibble\` com as colunas `valor` (código do setor), `descricao`
(rótulo) e `localidade` (código da localidade; ver
[`localidades`](https://distintivelab.github.io/pdadr/reference/localidades.md)).

## Examples

``` r
head(setores())
#> # A tibble: 6 × 3
#>   valor descricao             localidade
#>   <chr> <chr>                 <chr>     
#> 1 1     Plano Piloto - Área 1 5301      
#> 2 2     Plano Piloto - Área 2 5301      
#> 3 3     Plano Piloto - Área 3 5301      
#> 4 4     Plano Piloto - Área 4 5301      
#> 5 5     Gama                  5302      
#> 6 6     Taguatinga            5303      
setores(localidade = "Sobradinho")   # por nome
#> # A tibble: 1 × 3
#>   valor descricao  localidade
#>   <chr> <chr>      <chr>     
#> 1 8     Sobradinho 5305      
setores(localidade = "5247")         # por código (Luziânia-GO)
#> # A tibble: 2 × 3
#>   valor descricao         localidade
#>   <chr> <chr>             <chr>     
#> 1 53    Luziânia - Área 1 5247      
#> 2 54    Luziânia - Área 2 5247      
```
