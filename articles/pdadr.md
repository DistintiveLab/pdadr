# Introdução ao pdadr

``` r

library(pdadr)
```

O pacote **pdadr** dá acesso aos microdados da Pesquisa Distrital por
Amostra de Domicílios do Distrito Federal e entorno (PDAD-A) 2024,
divulgados pelo IPE/DF em <https://pdad.ipe.df.gov.br/>, e acompanha uma
tabela de metadados completa das bases de **domicílios** e
**moradores**.

## Metadados

A tabela `pdadmeta` reúne, em formato longo (tidy), o dicionário de
variáveis oficial: para cada variável, sua descrição e, quando
codificada, os códigos e respectivos rótulos.

``` r

# consultar os metadados de uma variável
dicionario(coluna = "localidade")

# todas as variáveis da base de moradores
dicionario(base = "moradores")

# busca por expressão regular: todas as variáveis de renda
dicionario(coluna = "^renda|renda$")
```

A coluna `anexo` indica de qual planilha do dicionário oficial os
códigos foram extraídos (“anexo_1” a “anexo_11”).

## Microdados

[`get_pdad()`](https://distintivelab.github.io/pdadr/reference/get_pdad.md)
baixa e lê as bases, com cache local (o download ocorre uma única vez
por máquina):

``` r

dom <- get_pdad("domicilios")
mor <- get_pdad("moradores")

# as duas bases de uma vez (lista nomeada)
dados <- get_pdad(c("domicilios", "moradores"))
```

Com `rotular = TRUE`, as variáveis codificadas já retornam como `factor`
com os rótulos do dicionário:

``` r

dom <- get_pdad("domicilios", rotular = TRUE)
table(dom$localidade)
```

Também é possível rotular um data.frame já carregado com
[`rotular()`](https://distintivelab.github.io/pdadr/reference/rotular.md),
que infere a base a partir das colunas presentes.

## Pesos e análise

As bases trazem pesos de expansão: `peso_dom` (domicílios) e `peso_mor`
(moradores), além do deflator `infla_ipcadf` para as variáveis de renda
(sufixo `_r` já deflate os valores). Para estimativas complexas,
considere carregar as bases em um pacote de análise amostral (ex.:
`survey`) usando esses pesos.
