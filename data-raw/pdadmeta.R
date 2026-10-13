# Script para gerar a tabela de metadados `pdadmeta` a partir do
# dicionário de variáveis público da PDAD-A 2024 (IPE/DF).
#
# Fonte: https://pdad.ipe.df.gov.br/files/reports/dicionario_de_variaveis_pdada_2024_p%C3%BAblico.xlsx
#
# Executar manualmente quando uma nova edição do dicionário for publicada:
#   source("data-raw/pdadmeta.R", encoding = "UTF-8")

library(readxl)

arq_dic <- "data-raw/dicionario_de_variaveis_pdada_2024_publico.xlsx"

## ------------------------------------------------------------------
## 1. Parsing dos anexos (tabelas de códigos compartilhadas)
##    Cada anexo vira um tibble: coluna | valor | descricao
## ------------------------------------------------------------------

preenche_abaixo <- function(x) {
  x[is.na(x)] <- ""
  trimws(ave(as.character(x), FUN = function(v) {
    for (i in seq_along(v)) if (!nzchar(v[i])) v[i] <- v[i - 1]
    v
  }))
}

# anexos com layout padrão de 3 colunas; células de "Coluna" podem listar
# várias variáveis separadas por quebra de linha (ex.: anexo_3, anexo_6)
ler_anexo_simples <- function(planilha) {
  d <- as.data.frame(read_excel(arq_dic, sheet = planilha))
  d <- d[, 1:3]
  names(d) <- c("coluna", "valor", "descricao")
  d$coluna <- preenche_abaixo(d$coluna)
  d <- d[!is.na(d$valor) & d$valor != "-", ]
  d$descricao <- ifelse(is.na(d$descricao), "", as.character(d$descricao))
  # células com texto quebrado em colunas vizinhas (anexo_4, linhas 4 e 5)
  if (ncol(as.data.frame(read_excel(arq_dic, sheet = planilha))) > 3) {
    extra <- as.data.frame(read_excel(arq_dic, sheet = planilha))[, 4:5]
    completa <- apply(extra, 1, function(l) paste(na.omit(l), collapse = " "))
    d$descricao <- trimws(paste(d$descricao, completa))
  }
  ret <- do.call(rbind, lapply(seq_len(nrow(d)), function(i) {
    vars <- trimws(strsplit(d$coluna[i], "[\r\n]+")[[1]])
    vars <- vars[nzchar(vars)]
    data.frame(anexo = planilha, coluna = vars,
               valor = as.character(d$valor[i]),
               descricao = d$descricao[i])
  }))
  ret[ret$coluna != "", ]
}

# anexo_7 traz dois blocos lado a lado (E19_1 e E20_1); o segundo bloco
# está vazio, indicando que E20_1 compartilha os códigos de E19_1
ler_anexo_duplo <- function(planilha) {
  d <- as.data.frame(read_excel(arq_dic, sheet = planilha))
  g1 <- data.frame(coluna = d[[1]][1], valor = d[[2]][-1],
                   descricao = d[[3]][-1])
  g2 <- data.frame(coluna = d[[6]][1], valor = d[[7]][-1],
                   descricao = d[[8]][-1])
  out <- NULL
  for (g in list(g1, g2)) {
    if (is.na(g$coluna[1]) || all(is.na(g$valor))) next
    out <- rbind(out, data.frame(anexo = planilha,
                                 coluna = g$coluna[1],
                                 valor = as.character(na.omit(g$valor)),
                                 descricao = as.character(na.omit(g$descricao))))
  }
  # bloco 2 vazio: replica códigos do bloco 1 para a variável do bloco 2
  var2 <- d[[6]][1]
  if (!is.na(var2) && !any(out$coluna == var2)) {
    out <- rbind(out, data.frame(anexo = planilha, coluna = var2,
                                 valor = out$valor[out$coluna == d[[1]][1]],
                                 descricao = out$descricao[out$coluna == d[[1]][1]]))
  }
  out
}

# anexo_10 e anexo_11 trazem uma linha de cabeçalho interna
ler_anexo_cabecalho <- function(planilha) {
  d <- as.data.frame(read_excel(arq_dic, sheet = planilha, col_names = FALSE))
  names(d) <- c("coluna", "valor", "descricao")
  d <- d[-1, ]
  d$coluna <- preenche_abaixo(d$coluna)
  d <- d[!is.na(d$valor) & d$valor != "-", ]
  data.frame(anexo = planilha, coluna = d$coluna,
             valor = as.character(d$valor),
             descricao = as.character(d$descricao))
}

anexos <- c(
  lapply(paste0("anexo_", 1:6), ler_anexo_simples),
  list(ler_anexo_duplo("anexo_7")),
  list(ler_anexo_simples("anexo_8")),
  list(ler_anexo_simples("anexo_9")),
  list(ler_anexo_cabecalho("anexo_10")),
  list(ler_anexo_cabecalho("anexo_11"))
)
names(anexos) <- paste0("anexo_", 1:11)
anexos <- anexos[vapply(anexos, nrow, integer(1)) > 0]

## ------------------------------------------------------------------
## 2. Planilhas principais (domicilios, moradores) + expansão das
##    referências "Ver Anexo N"
## ------------------------------------------------------------------

expandir_anexo <- function(nome_anexo, var) {
  a <- anexos[[nome_anexo]]
  linhas <- a[a$coluna == var, ]
  if (nrow(linhas) == 0) linhas <- a  # anexo sem correspondência exata
  linhas
}

ler_base <- function(base) {
  d <- as.data.frame(read_excel(arq_dic, sheet = base))
  names(d)[1:4] <- c("coluna", "descricao_coluna", "valor", "descricao_valor")
  d$coluna <- preenche_abaixo(d$coluna)
  d$descricao_coluna <- preenche_abaixo(as.character(d$descricao_coluna))

  d <- d[nzchar(d$coluna) & !is.na(d$valor), ]
  d$descricao_valor <- ifelse(is.na(d$descricao_valor), "",
                              as.character(d$descricao_valor))

  resumo <- do.call(rbind, lapply(split(d, seq_len(nrow(d))), function(l) {
    var <- l$coluna
    desc <- l$descricao_coluna
    ref <- l$descricao_valor
    num_anexo <- regmatches(ref, regexpr("Anexo \\d+", ref))
    if (length(num_anexo) == 1) {
      a <- expandir_anexo(tolower(gsub(" ", "_", num_anexo)), var)
      data.frame(base = base, coluna = var,
                 descricao_coluna = desc,
                 valor = a$valor, descricao_valor = a$descricao,
                 anexo = a$anexo)
    } else if (l$valor == "-") {
      data.frame(base = base, coluna = var,
                 descricao_coluna = desc,
                 valor = NA_character_, descricao_valor = NA_character_,
                 anexo = NA_character_)
    } else {
      data.frame(base = base, coluna = var,
                 descricao_coluna = desc,
                 valor = as.character(l$valor),
                 descricao_valor = l$descricao_valor,
                 anexo = NA_character_)
    }
  }))
  resumo
}

pdadmeta <- rbind(ler_base("domicilios"), ler_base("moradores"))
row.names(pdadmeta) <- NULL
pdadmeta$base <- factor(pdadmeta$base, levels = c("domicilios", "moradores"))

save(pdadmeta, file = "data/pdadmeta.rda", compress = "bzip2")

nd <- length(unique(pdadmeta$coluna[pdadmeta$base == "domicilios"]))
nm <- length(unique(pdadmeta$coluna[pdadmeta$base == "moradores"]))
message("pdadmeta gerado: ", nrow(pdadmeta), " linhas, ",
        nd + nm, " variáveis (", nd, " domicilios, ", nm, " moradores)")
