# Roadmap do pacote pdadr

Pacote de R para acessar e processar os microdados da PDAD-A 2024
(IPE/DF, <https://pdad.ipe.df.gov.br/>), seguindo o padrão do pacote
[sidra](https://github.com/rodrigoesborges/sidra): metadados versionados
dentro do pacote + funções de consulta e leitura. Consumidor previsto:
[distintivelab/beep](https://github.com/distintivelab/beep).

## Fase 0 - Concluído (esqueleto e primeiras funções)

- [x] Inspecionar fontes: zips de `domicilios` (24.845 registros, 128
  colunas) e `moradores` (69.542 registros, 134 colunas), CSV `;`-separado
  em UTF-8 com BOM
- [x] Inspecionar o dicionário oficial (`dicionario_de_variaveis...xlsx`):
  planilhas principais + 11 anexos de códigos
- [x] `DESCRIPTION`, `NAMESPACE`, `.Rproj`, `.gitignore`, `.Rbuildignore`
- [x] Tabela de metadados `pdadmeta` (data/): 19.494 linhas, 128 variáveis
  de domicílios + 134 de moradores, com expansão dos 11 anexos
  (`data-raw/pdadmeta.R`)
- [x] `dicionario(base, coluna)`: consulta à tabela de metadados, com
  regex na busca de variáveis
- [x] `get_pdad(base, rotular, dir_cache, forcar)`: download com cache
  local (`R_user_dir`), leitura e rotulagem opcionais
- [x] `rotular(dados, base)`: inferência da base pelas colunas-chave
  (`peso_dom`/`peso_mor`) e conversão em `factor` somente quando os
  valores observados estão integralmente no dicionário
- [x] `fontes()`: URLs oficiais (microdados, dicionário, questionário)
- [x] Testes (testthat, 39 asserções) com fixtures de 5 registros das
  bases reais, sem depender de rede
- [x] GitHub Actions: `R-CMD-check` (5 plataformas) e `pkgdown`
- [x] `_pkgdown.yml` (pt-BR), vignette introdutória, README

## Fase 1 - Publicação

- [x] `git init`, primeiro commit, criar repositório
      `distintivelab/pdadr` e publicar (main)
- [x] Branch `gh-pages` criado pelo workflow `pkgdown.yaml`; site em
      <https://distintivelab.github.io/pdadr/>
- [x] Badge de status do check no README; remover comentário de
      `install_github` quando o repositório estiver público
- [x] Logo do pacote (`man/figures/logo.svg` + `logo.png`)

## Fase 2 - Validação de metadados - Concluída

- [x] Auditoria sistemática `pdadmeta` vs microdados reais
      (`data-raw/auditoria_metadados.R` + relatório em
      `data-raw/auditoria_metadados.csv`): 176 variáveis ok; 47 de
      quantidade com códigos reservados; 28 sem códigos; 4 texto livre;
      3 com código reservado omitido; 4 divergências genuínas (D15,
      E15_B, G06_1, G06_2)
- [x] Corrigido bug do parser do anexo_7: primeiro código (76110001)
      de E19_1/E20_1 era descartado
- [x] Documentar na vignette os códigos reservados (77777 = Recusa,
      88888 = Não sabe, 99999 = Não se aplica; 185 variáveis) e as
      particularidades (vírgula decimal, colunas de quantidade,
      lacunas do dicionário oficial)
- [x] Teste de não-regressão: dimensões das bases (24.845×128 e
      69.542×134) e somas dos pesos de expansão
      (1.806.637,76 domicílios; 4.255.723,77 moradores)

## Fase 3 - Facilidades para análise - Concluída

- [x] Helpers de filtragem territorial: `localidades()` e `setores()` sobre
      as tabelas empacotadas `pdad_localidades` (48 localidades: 36 RAs do
      DF + 12 municípios de GO) e `pdad_setores` (58 setores →
      localidade), geradas por `data-raw/localidades.R`
- [x] Harmonização com códigos do IBGE (compatível com shapefiles do
      Censo 2022 e com o geobr): `cod_ibge_municipio` (DF = 5300108,
      único município; GO = código do município) e
      `cod_ibge_subdistrito` (RAs do DF como subdistritos do Censo 2022,
      11 dígitos; 33/36 RAs cobertas — Arapoanga e Água Quente foram
      criadas após o Censo 2022 e Área Rural não é subdistrito do IBGE)
- [x] Funções de estimativa com pesos: `estimar()` (média/total/proporção
      ponderados, com desagregação via `por`), `limpar_reservados()`
      (77777/88888/99999 → NA) e documentação do deflator
      `infla_ipcadf` (rendas `_r` já deflacionadas)
- [x] Suporte opcional a `survey` via `design_pdad()` (desenho apenas
      ponderado: o IPE/DF não divulga UPAs/estratos, erros-padrão não são
      válidos para inferência); `survey` em `Suggests`
- [x] Cruzamento domicílio-moradores por `A01nficha` com
      `juntar_bases()` ("moradores" = left join, "completo" = full join,
      sufixos `_mor`/`_dom`)
- [x] Vignette: seções "Pesos e análise" e "Territórios e harmonização
      com o IBGE e o geobr" (mapas por município e por RA via dissolução
      de setores censitários); 137 asserções de teste e `R CMD check`
      0 erros / 0 warnings / 0 notes

## Fase 4 - Integração com o ecossistema - Concluída (exceto submissão ao CRAN)

- [x] Interface confirmada para o consumo pelo beep (distintivelab):
      `pdadmeta` (códigos como `character`) e a saída de `get_pdad()`
      (tibbles) já no formato esperado; `cod_ibge_municipio` (7 dígitos) e
      `cod_ibge_subdistrito` (11 dígitos: município 7d + sequencial 4d)
      aderem ao esquema `geoloc_id` do beep, que já trata subdistrito
      (no DF, região administrativa) como nível territorial
- [x] Release `v0.1.0` publicado no GitHub
- [x] `R CMD check --as-cran` limpo (única NOTE: primeira submissão)
- [x] `codemeta.json` (`codemetar::write_codemeta()`) e rascunho de
      `cran-comments.md`
- [x] `NEWS.md` e `inst/CITATION` (pacote + fonte dos dados IPE/DF)
- [x] Submissão ao CRAN: 0.1.0 enviada em 14/10/2026, aguardando
      confirmação por e-mail e revisão editorial (metadados em inglês;
      exemplos com download em `\dontrun`)

## Fase 5 - Edições futuras da PDAD

- [ ] Quando o IPE/DF divulgar nova edição: atualizar URLs em
      `R/pdadr-package.R` (os nomes de arquivo carregam sufixo aleatório
      definido pelo site), regenerar `pdadmeta` via `data-raw/pdadmeta.R`
      e versionar os metadados por edição (ex.: argumento `edicao` ou
      dados `pdadmeta_<ano>`)
- [ ] Considerar painel de download direto no site do IPE/DF para
      descoberta automática de novas divulgações

## Decisões de design (registradas)

- Metadados **empacotados** (`.rda`) e não baixados em tempo de uso:
      consultas `dicionario()` funcionam offline e o consumidor (beep)
      pode depender de `pdadmeta` diretamente; regeneração é manual via
      `data-raw/`
- `valor` mantido como `character` na tabela de metadados: preserva
      códigos com zeros à esquerda e evita coerção silenciosa; a
      comparação em `rotular()` usa `as.character()`
- `rotular()` não converte colunas cujos valores observados não estão
      100% cobertos pelo dicionário (proteção contra perda de dados por
      NA forçado); lacunas conhecidas ficam documentadas
- Cache único por máquina (`tools::R_user_dir`) em vez de cache por
      projeto: os zips têm ~6 MB e servem qualquer análise
- Sem dependência de `httr`: os downloads são diretos de arquivos
      estáticos (`utils::download.file`)
- Harmonização territorial como dados empacotados
      (`pdad_localidades`/`pdad_setores`, com códigos IBGE verificados e
      registrados em `data-raw/localidades.R`): geobr/sf ficam em
      `Suggests` e o uso offline não depende de rede
- RAs do DF correspondem a **subdistritos** do Censo 2022 (11 dígitos),
      não a municípios: o DF é um único município IBGE (5300108); a
      vignette documenta a dissolução de setores censitários
      (`geobr::read_census_tract()` + `stats::aggregate`) para obter
      polígonos por RA
- `estimar()` devolve apenas estimativas pontuais (sem erro-padrão);
      `design_pdad()` cobre o acesso ao ecossistema `survey` com a
      limitação de variância documentada
