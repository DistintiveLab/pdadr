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
- [ ] Badge de status do check no README; remover comentário de
      `install_github` quando o repositório estiver público
- [ ] Logo do pacote (`man/figures/logo.png`)

## Fase 2 - Validação de metadados

- [ ] Auditoria sistemática `pdadmeta` vs microdados reais: para cada
      variável codificada, comparar domínio observado com o dicionário;
      registrar lacunas (já conhecidas: `localidade` não codificada na
      planilha de moradores; `renda_*`, `peso_*`, `grupo_ped`, `UPT`,
      `criterio_brasil`, `arranjos` e derivadas não têm códigos)
- [ ] Documentar na vignette os códigos reservados (ex.: 88888, 99999) e
      as convenções de perdidos/não se aplica
- [ ] Teste de não-regressão: contagens de linhas e colunas das bases
      (contra checksums fixos)

## Fase 3 - Facilidades para análise

- [ ] Helpers de filtragem territorial: `localidade` (RAs, anexo_1) e
      `setor_distrito` (anexo_2) com nomes amigáveis
- [ ] Funções de estimativa com pesos (`peso_dom`/`peso_mor`) e
      documentação do deflator `infla_ipcadf` (rendas `_r` já deflate)
- [ ] Suporte opcional a `survey` (design amostral), sem torná-lo
      dependência obrigatória (`Suggests`)
- [ ] Cruzamento domicílio-moradores por `A01nficha`

## Fase 4 - Integração com o ecossistema

- [ ] Ajustar interface para o consumo pelo beep (distintivelab):
      confirmar formato de `pdadmeta`/saída de `get_pdad` com o
      consumidor e publicar release `v0.1.0`
- [ ] Submissão ao CRAN (opcional): `R CMD check --as-cran` limpo,
      `codemeta`, `cran-comments.md`
- [ ] NEWS.md, `CITATION`, `codemetar::write_codemeta()`

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
