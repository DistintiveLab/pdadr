# Objeto de desenho amostral para a PDAD-A 2024

Cria um objeto de desenho amostral (survey) a partir dos microdados da
PDAD-A 2024, usando os pesos de expansão. Útil para replicar com
[`survey::svymean()`](https://rdrr.io/pkg/survey/man/surveysummary.html),
[`survey::svytotal()`](https://rdrr.io/pkg/survey/man/surveysummary.html),
[`survey::svyby()`](https://rdrr.io/pkg/survey/man/svyby.html) etc. as
estimativas pontuais de
[`estimar`](https://distintivelab.github.io/pdadr/reference/estimar.md).

## Usage

``` r
design_pdad(dados, base = NULL, ids = NULL, ...)
```

## Arguments

- dados:

  data.frame ou tibble com microdados da PDAD-A 2024.

- base:

  opcional: "domicilios" ou "moradores". Quando omitido, é inferido das
  colunas de pesos presentes.

- ids:

  fórmula de identificação das UPAs, repassada a
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html);
  o padrão `~1` indica desenho apenas ponderado.

- ...:

  outros argumentos repassados a
  [`survey::svydesign()`](https://rdrr.io/pkg/survey/man/svydesign.html)
  (ex.: `strata`, `fpc`).

## Value

Um objeto de classe `survey.design` criado com os pesos da base
informada.

## Details

O IPE/DF não divulga as unidades primárias de amostragem (UPAs) nem os
estratos da PDAD-A 2024, de modo que o desenho criado é apenas ponderado
(`ids = ~1`): erros-padrão produzidos por funções do survey subestimam a
variância amostral verdadeira e não devem ser usados para inferência. As
estimativas pontuais (médias, totais, proporções) não são afetadas por
essa limitação.

## Examples

``` r
if (FALSE) { # \dontrun{
desenho <- design_pdad(get_pdad("domicilios"))
# survey::svymean(~renda_domiciliar_r, desenho)
} # }
```
