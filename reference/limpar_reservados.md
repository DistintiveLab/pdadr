# Remove códigos reservados dos microdados da PDAD-A 2024

Substitui por `NA` os códigos reservados do questionário da PDAD-A 2024
presentes em colunas numéricas: 77777 (Recusa), 88888 (Não sabe) e 99999
(Não se aplica). Use antes de calcular estimativas com
[`estimar`](https://distintivelab.github.io/pdadr/reference/estimar.md).

## Usage

``` r
limpar_reservados(dados, reservados = c(77777, 88888, 99999))
```

## Arguments

- dados:

  data.frame ou tibble com microdados da PDAD-A 2024.

- reservados:

  códigos reservados a substituir.

## Value

Um \`tibble\` com os códigos reservados das colunas numéricas
substituídos por `NA`.

## Examples

``` r
d <- data.frame(renda = c(2000, 77777, 88888), peso_dom = c(1, 1, 1))
limpar_reservados(d)
#> # A tibble: 3 × 2
#>   renda peso_dom
#>   <dbl>    <dbl>
#> 1  2000        1
#> 2    NA        1
#> 3    NA        1
```
