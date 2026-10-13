# Estimativas ponderadas a partir dos microdados da PDAD-A 2024

Calcula médias, totais e proporções ponderadas pelos pesos de expansão
da PDAD-A 2024 (`peso_dom` na base de domicílios; `peso_mor` na de
moradores), opcionalmente desagregadas por grupos (ex.: por `localidade`
ou `setor_distrito`).

## Usage

``` r
estimar(
  dados,
  variavel,
  tipo = c("media", "total", "proporcao"),
  por = NULL,
  peso = NULL,
  na_rm = TRUE
)
```

## Arguments

- dados:

  data.frame ou tibble com microdados da PDAD-A 2024.

- variavel:

  nome da variável de interesse (length 1).

- tipo:

  "media" (média ponderada), "total" (soma ponderada) ou "proporcao"
  (participação ponderada de cada nível quando a variável é qualitativa,
  ou média ponderada quando é lógica ou 0/1).

- por:

  opcional: vetor com nomes de colunas para desagregar a estimativa
  (ex.: `c("localidade")`).

- peso:

  opcional: nome da coluna de pesos. Se omitido, usa `peso_dom` ou
  `peso_mor`, quando identificável.

- na_rm:

  lógico; quando `TRUE` (padrão), exclui observações com `NA` na
  variável de interesse.

## Value

Um \`tibble\`. Para `tipo = "media"` e `"total"`: colunas de `por`,
`estimativa` e `n` (número de observações válidas, sem peso). Para
`tipo = "proporcao"` com variável qualitativa: inclui também a coluna
`nivel`.

## Details

O peso é inferido a partir das colunas presentes: `peso_dom` na ausência
de `peso_mor` e `peso_mor` na ausência de `peso_dom`; quando ambos
existem (ex.: resultado de
[`juntar_bases`](https://distintivelab.github.io/pdadr/reference/juntar_bases.md)),
informe o argumento `peso` explicitamente.

Para rendas, prefira as variáveis com sufixo `"_r"`, que já vêm
corrigidas pela inflação (multiplicadas por `infla_ipcadf`, fator do
IPCA-DF divulgado com os microdados). Atenção aos códigos reservados
(77777 = Recusa, 88888 = Não sabe, 99999 = Não se aplica), presentes em
diversas variáveis: use
[`limpar_reservados`](https://distintivelab.github.io/pdadr/reference/limpar_reservados.md)
antes de estimar.

## Examples

``` r
# \donttest{
dom <- get_pdad("domicilios")
# renda domiciliar média por RA (valores corrigidos pela inflação)
estimar(dom, "renda_domiciliar_r", tipo = "media", por = "localidade")
#> # A tibble: 48 × 3
#>    localidade estimativa     n
#>         <int>      <dbl> <int>
#>  1       5330     68545.   802
#>  2       5320     89541.   402
#>  3       5315     76306.   452
#>  4       5326     89519.   570
#>  5       5314     79169.   800
#>  6       5303     80112.   423
#>  7       5311     81350.   399
#>  8       5241     73912.   400
#>  9       5313     89166.   451
#> 10       5328     80407.   401
#> # ℹ 38 more rows

# proporção ponderada de domicílios por situação (após rotular)
estimar(rotular(dom), "A01uf", tipo = "proporcao")
#> # A tibble: 2 × 3
#>   nivel            estimativa     n
#>   <chr>                 <dbl> <int>
#> 1 Distrito Federal      0.684 18130
#> 2 Goiás                 0.316  6715
# }
```
