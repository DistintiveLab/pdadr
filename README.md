Vamos fazer um pacote de R para acessar e processar microdados da Pesquisa Distrital por Amostra de Domicílios, PDAD-A 2024, disponível em:
https://pdad.ipe.df.gov.br/


É para utilizar como exemplo o pacote rodrigoesborges/sidra , pois precisamos fazer uma tabela de metadados já que temos distintivelab/beep que será consumidor de pdadr

Crie já com estrutura de pkgdown no branch gh-pages e github actions para documentação

Os links dos arquivos zip para preprocessamento são, conforme pdad.ipe.df.gov.br :

https://pdad.ipe.df.gov.br/files/reports/Questionario_PDAD_A_2024_publico_RblethQ.pdf
https://pdad.ipe.df.gov.br/files/reports/dicionario_de_variaveis_pdada_2024_p%C3%BAblico.xlsx
https://pdad.ipe.df.gov.br/files/reports/domicilios_QrV9v7y.zip
https://pdad.ipe.df.gov.br/files/reports/moradores_60wwMwo.zip

---

# pdadr <img src="man/figures/logo.png" align="right" height="138" alt="" />

<!-- badges: start -->
<!-- badges: end -->

Acesso e processamento dos microdados da Pesquisa Distrital por Amostra
de Domicílios do Distrito Federal e entorno (PDAD-A) 2024, divulgados
pelo IPE/DF em <https://pdad.ipe.df.gov.br/>. O pacote acompanha uma
tabela de metadados completa (dicionário de variáveis e códigos) das
bases de domicílios e moradores, para consumo próprio e por outros
pacotes (ex.: [distintivelab/beep](https://github.com/distintivelab/beep)).

## Instalação

```r
# remotes::install_github("distintivelab/pdadr")
```

## Uso

```r
library(pdadr)

# dicionário de variáveis e códigos
dicionario(coluna = "localidade")

# download (com cache) e leitura dos microdados
dom <- get_pdad("domicilios")
mor <- get_pdad("moradores", rotular = TRUE)

# fontes oficiais dos arquivos
fontes()
```

## Estrutura

- `get_pdad()`: baixa e lê as bases de microdados (cache local em
  `tools::R_user_dir("pdadr", "cache")`)
- `rotular()`: converte variáveis codificadas em `factor` com os rótulos
  do dicionário
- `dicionario()`: consulta à tabela de metadados `pdadmeta` (19.494
  linhas, 262 variáveis)
- `fontes()`: endereços oficiais dos arquivos divulgados pelo IPE/DF

Consulte o [roadmap](ROADMAP.md) para o estado de evolução do pacote.
