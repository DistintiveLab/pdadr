# pdadr 0.1.0

* Primeiro release.
* Metadados versionados: tabela `pdadmeta` (19.494 linhas; 128 variáveis da
  base de domicílios e 134 da de moradores, com os 11 anexos de códigos
  expandidos) e função `dicionario()` para consulta, com busca por regex.
* `get_pdad()` faz o download (com cache local) e a leitura dos microdados
  das bases de domicílios e moradores, com rotulagem opcional por `rotular()`;
  `fontes()` devolve as URLs oficiais dos arquivos.
* Estimativas ponderadas: `estimar()` (média, total e proporção, com
  desagregação por grupos), `limpar_reservados()` (códigos reservados
  77777/88888/99999 convertidos em `NA`) e `design_pdad()` para uso com o
  pacote survey, com a limitação de variância documentada.
* `juntar_bases()` cruza as bases de domicílios e moradores por `A01nficha`
  (left ou full join, com sufixos `_mor`/`_dom`).
* Harmonização territorial com os códigos do IBGE, compatível com shapefiles
  do Censo 2022 e com o pacote geobr: tabelas `pdad_localidades` (48
  localidades com `cod_ibge_municipio` e `cod_ibge_subdistrito`) e
  `pdad_setores` (58 setores mapeados a localidade), consultadas por
  `localidades()` e `setores()`.
* Vignette introdutória: dicionário, códigos reservados, pesos e deflator
  `infla_ipcadf` (rendas com sufixo `_r`), e mapas por município e por
  região administrativa.
