# Rotula variáveis codificadas da PDAD-A 2024

Converte as variáveis codificadas de um data.frame de microdados da
PDAD-A 2024 em `factor`, atribuindo os rótulos do dicionário de
variáveis. Variáveis cujos valores observados não estejam integralmente
cobertos pelo dicionário são mantidas inalteradas.

## Usage

``` r
rotular(dados, base = NULL)
```

## Arguments

- dados:

  data.frame ou tibble com microdados da PDAD-A 2024.

- base:

  opcional: "domicilios" ou "moradores".

## Value

Um \`tibble\` com as mesmas colunas de `dados`, tendo as variáveis
codificadas convertidas para `factor`.

## Details

A base é inferida automaticamente a partir das colunas presentes
(`peso_dom` indica domicílios; `peso_mor` indica moradores), mas pode
ser informada explicitamente.

## Examples

``` r
if (FALSE) { # \dontrun{
dom <- get_pdad("domicilios")
dom_rot <- rotular(dom)
table(dom_rot$localidade)
} # }
```
