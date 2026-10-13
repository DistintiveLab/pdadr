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
# \donttest{
dom <- get_pdad("domicilios")
dom_rot <- rotular(dom)
table(dom_rot$localidade)
#> 
#>                Plano Piloto                        Gama 
#>                        1623                         400 
#>                  Taguatinga                  Brazlândia 
#>                         423                         399 
#>                  Sobradinho                  Planaltina 
#>                         525                         463 
#>                     Paranoá          Núcleo Bandeirante 
#>                         464                         425 
#>                   Ceilândia                       Guará 
#>                         560                         409 
#>                    Cruzeiro                   Samambaia 
#>                         399                         553 
#>                 Santa Maria               São Sebastião 
#>                         451                         800 
#>            Recanto Das Emas                    Lago Sul 
#>                         452                         399 
#>                Riacho Fundo                  Lago Norte 
#>                         642                         403 
#>              Candangolândia                Águas Claras 
#>                         403                         402 
#>             Riacho Fundo II        Sudoeste e Octogonal 
#>                         401                         396 
#>                      Varjão                    Park Way 
#>                         409                         399 
#>                        SCIA               Sobradinho II 
#>                         844                         570 
#>             Jardim Botânico                      Itapoã 
#>                         401                         401 
#>                         SIA               Vicente Pires 
#>                         150                         802 
#>                      Fercal   Sol Nascente / Pôr do Sol 
#>                         400                         399 
#>                  Arniqueira                   Arapoanga 
#>                         604                         509 
#>                 Água Quente                  Área Rural 
#>                         400                         450 
#>       Águas Lindas de Goiás                    Alexânia 
#>                         400                         693 
#>            Cidade Ocidental                  Cristalina 
#>                         800                         806 
#>         Cocalzinho de Goiás                     Formosa 
#>                         400                         400 
#>                    Luziânia                   Novo Gama 
#>                         800                         403 
#>              Padre Bernardo         Planaltina de Goiás 
#>                         800                         399 
#> Santo Antônio do Descoberto         Valparaíso de Goiás 
#>                         412                         402 
# }
```
