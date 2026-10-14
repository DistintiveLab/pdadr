# Cruza as bases de domicílios e moradores da PDAD-A 2024

Combina as bases de domicílios e moradores pela chave do domicílio
(`A01nficha`). Colunas presentes nas duas bases recebem sufixos `"_dom"`
e `"_mor"` (ex.: `localidade_dom` e `localidade_mor`), com exceção da
própria chave.

## Usage

``` r
juntar_bases(domicilios, moradores, como = c("moradores", "completo"))
```

## Arguments

- domicilios:

  data.frame ou tibble da base de domicílios (saída de
  [`get_pdad`](https://distintivelab.github.io/pdadr/reference/get_pdad.md)).

- moradores:

  data.frame ou tibble da base de moradores (saída de
  [`get_pdad`](https://distintivelab.github.io/pdadr/reference/get_pdad.md)).

- como:

  "moradores" (padrão): mantém todas as linhas de moradores, agregando
  as colunas do domicílio; "completo": mantém também domicílios sem
  moradores na amostra de moradores.

## Value

Um \`tibble\` resultante do cruzamento pela coluna `A01nficha`.

## Details

Como o resultado contém os dois pesos (`peso_dom` e `peso_mor`), informe
explicitamente o argumento `peso` ao usar
[`estimar`](https://distintivelab.github.io/pdadr/reference/estimar.md),
ou `base` ao usar
[`design_pdad`](https://distintivelab.github.io/pdadr/reference/design_pdad.md).

## Examples

``` r
if (FALSE) { # \dontrun{
bases <- get_pdad(c("domicilios", "moradores"))
dados <- juntar_bases(bases$domicilios, bases$moradores)
# estimar por morador exige informar o peso:
# estimar(dados, "renda_total_r", tipo = "media", peso = "peso_mor")
} # }
```
