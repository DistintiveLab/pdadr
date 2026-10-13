# Tabela de metadados da PDAD-A 2024

Tabela de metadados completa das bases de microdados da PDAD-A 2024,
obtida a partir do dicionário de variáveis público do IPE/DF. Contém,
para cada variável das bases de domicílios e moradores, sua descrição e,
quando codificada, a lista de códigos e respectivos rótulos.

## Usage

``` r
pdadmeta
```

## Format

data.frame com 19.496 linhas e 6 colunas:

- base:

  base de origem: "domicilios" ou "moradores"

- coluna:

  nome da variável, conforme cabeçalho dos arquivos CSV

- descricao_coluna:

  descrição da variável no dicionário

- valor:

  código observado na base; `NA` para variáveis não codificadas

- descricao_valor:

  rótulo do código; `NA` para variáveis não codificadas

- anexo:

  planilha do dicionário de onde os códigos foram extraídos ("anexo_1" a
  "anexo_11"); `NA` quando a codificação está na própria planilha da
  base

## Source

Extraído de
<https://pdad.ipe.df.gov.br/files/reports/dicionario_de_variaveis_pdada_2024_publico.xlsx>.
O script de geração está em `data-raw/pdadmeta.R`.

## Examples

``` r
data(pdadmeta)
head(pdadmeta)
#>         base     coluna                                        descricao_coluna
#> 1 domicilios  starttime                                   Data e hora da visita
#> 2 domicilios  A01nficha                                         Número da ficha
#> 3 domicilios      A01uf                                    Unidade da Federação
#> 4 domicilios      A01uf                                    Unidade da Federação
#> 5 domicilios localidade Região Administrativa (DF) ou Município da amostra (GO)
#> 6 domicilios localidade Região Administrativa (DF) ou Município da amostra (GO)
#>   valor  descricao_valor   anexo
#> 1  <NA>             <NA>    <NA>
#> 2  <NA>             <NA>    <NA>
#> 3    52            Goiás    <NA>
#> 4    53 Distrito Federal    <NA>
#> 5  5301     Plano Piloto anexo_1
#> 6  5302             Gama anexo_1
```
