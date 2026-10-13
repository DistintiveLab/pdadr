# Comentários para o CRAN (rascunho — submissão pendente de decisão)

## Notas de teste

-   Primeira submissão do pacote.

-   O pacote acompanha apenas metadados da pesquisa PDAD-A 2024 (dicionário
    de variáveis processado); os microdados (~6 MB por base) são baixados
    sob demanda, com cache local, a partir das URLs oficiais do IPE/DF.
    Nenhum teste acessa a rede.

-   `R CMD check --as-cran` local (R 4.5.3, Ubuntu): 0 erros, 0 warnings;
    única NOTE a de primeira submissão.

## Ambientes de teste

-   GitHub Actions (R-CMD-check): ubuntu-latest (release, oldrel-1, devel),
    windows-latest (release), macos-latest (release).

-   Local: R 4.5.3, Ubuntu (pt_BR.UTF-8).
