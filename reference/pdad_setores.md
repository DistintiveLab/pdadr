# Tabela de setores da PDAD-A 2024

Correspondência entre os 58 setores da variável `setor_distrito`
(subdivisões das Regiões Administrativas e dos municípios da amostra,
conforme coleta da PDAD-A 2024) e as localidades a que pertencem.

## Usage

``` r
pdad_setores
```

## Format

data.frame com 58 linhas e 3 colunas:

- valor:

  código da variável `setor_distrito` nos microdados ("1" a "58")

- descricao:

  rótulo do setor no dicionário da PDAD-A 2024 (ex.: "Plano Piloto -
  Área 1")

- localidade:

  código da localidade (`valor` em
  [`pdad_localidades`](https://distintivelab.github.io/pdadr/reference/pdad_localidades.md))
  a que o setor pertence

## Source

Derivada da tabela `pdadmeta` (dicionário público da PDAD-A 2024). O
script de geração está em `data-raw/localidades.R`.

## Examples

``` r
data(pdad_setores)
head(pdad_setores)
#>   valor             descricao localidade
#> 1     1 Plano Piloto - Área 1       5301
#> 2     2 Plano Piloto - Área 2       5301
#> 3     3 Plano Piloto - Área 3       5301
#> 4     4 Plano Piloto - Área 4       5301
#> 5     5                  Gama       5302
#> 6     6            Taguatinga       5303
```
