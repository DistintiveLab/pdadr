# Tabela de localidades da PDAD-A 2024

Correspondência entre os 48 territórios da amostra da PDAD-A 2024 (36
Regiões Administrativas do DF e 12 municípios goianos do entorno) e os
códigos do IBGE, permitindo a harmonização com shapefiles do Censo e com
o pacote geobr.

## Usage

``` r
pdad_localidades
```

## Format

data.frame com 48 linhas e 7 colunas:

- valor:

  código da variável `localidade` nos microdados (5301 a 5336 para RAs
  do DF; 5241 a 5252 para municípios de GO)

- nome:

  nome do território conforme o dicionário da PDAD-A 2024

- uf:

  unidade da federação: "DF" ou "GO"

- tipo:

  "regiao_administrativa" (DF) ou "municipio" (GO)

- cod_ibge_municipio:

  código IBGE de 7 dígitos do município. Para o DF, todas as RAs
  pertencem ao município 5300108 (Brasília)

- cod_ibge_subdistrito:

  código IBGE de 11 dígitos do subdistrito do Censo 2022, que no DF
  corresponde às Regiões Administrativas; `NA` para municípios de GO e
  para as localidades criadas após o Censo 2022 (Arapoanga, Água Quente
  e Área Rural)

- nome_ibge:

  nome oficial do território no IBGE, incluído para conferência quando
  difere do nome usado pela PDAD (ex.: "Sudoeste e Octogonal" na PDAD e
  "Sudoeste/Octogonal" no IBGE)

## Source

Códigos de subdistrito extraídos dos setores censitários do Censo 2022
(`geobr::read_census_tract(5300108, year = 2022)`); códigos de
municípios goianos da API de localidades do IBGE. O script de geração
está em `data-raw/localidades.R`.

## Examples

``` r
data(pdad_localidades)
head(pdad_localidades)
#>   valor         nome uf                  tipo cod_ibge_municipio
#> 1  5301 Plano Piloto DF regiao_administrativa            5300108
#> 2  5302         Gama DF regiao_administrativa            5300108
#> 3  5303   Taguatinga DF regiao_administrativa            5300108
#> 4  5304   Brazlândia DF regiao_administrativa            5300108
#> 5  5305   Sobradinho DF regiao_administrativa            5300108
#> 6  5306   Planaltina DF regiao_administrativa            5300108
#>   cod_ibge_subdistrito    nome_ibge
#> 1          53001080506 Plano Piloto
#> 2          53001080507         Gama
#> 3          53001080508   Taguatinga
#> 4          53001080509   Brazlândia
#> 5          53001080510   Sobradinho
#> 6          53001080511   Planaltina
```
