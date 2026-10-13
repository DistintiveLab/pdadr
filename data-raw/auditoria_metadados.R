# Auditoria sistemática: pdadmeta vs microdados reais da PDAD-A 2024.
#
# Compara, para cada variável de cada base, o domínio observado nos
# microdados com os códigos registrados no dicionário (pdadmeta) e
# classifica as divergências:
#
#   ok                              valores observados 100% no dicionário
#   sem_codigos_no_dicionario       dicionário lista a variável sem códigos
#   numerica_com_codigos_especiais  coluna numérica (quantidade, valor)
#                                   cujo dicionário só registra os códigos
#                                   reservados (77777, 88888, 99999) e
#                                   eventualmente "0 = Não tem"; valores
#                                   numéricos livres são esperados
#   codigo_ausente_no_dicionario    valores (em geral reservados) observados
#                                   nos dados mas omitidos no dicionário
#   texto_livre                     respostas textuais em coluna tratada
#                                   como codificada no dicionário
#   divergencia                     exige revisão manual
#
# Executar após qualquer regeneração de pdadmeta:
#   source("data-raw/auditoria_metadados.R", encoding = "UTF-8")

pkgload::load_all(".", quiet = TRUE)

ESPECIAIS <- c("77777", "88888", "99999", "777777", "888888", "999999")

dados <- get_pdad(c("domicilios", "moradores"))
meta <- pdadr::pdadmeta

auditoria <- do.call(rbind, lapply(c("domicilios", "moradores"), function(b) {
  df <- dados[[b]]
  mb <- meta[meta$base == b, ]
  do.call(rbind, lapply(unique(mb$coluna), function(v) {
    codigos <- mb$valor[mb$coluna == v]
    obs <- unique(as.character(stats::na.omit(df[[v]])))
    if (all(is.na(codigos))) {
      return(data.frame(base = b, coluna = v,
                        situacao = "sem_codigos_no_dicionario",
                        n_distintos = length(obs),
                        n_fora = NA_integer_, fora = NA_character_))
    }
    fora <- setdiff(obs, codigos)
    codigos_uteis <- setdiff(codigos, ESPECIAIS)
    extras_numericos <- all(grepl("^-?[0-9]+([.,][0-9]+)?$", fora))
    situacao <- if (length(fora) == 0) {
      "ok"
    } else if (all(codigos_uteis %in% "0") && extras_numericos) {
      "numerica_com_codigos_especiais"
    } else if (length(fora) <= 3 && all(fora %in% ESPECIAIS)) {
      "codigo_ausente_no_dicionario"
    } else if (!extras_numericos) {
      "texto_livre"
    } else {
      "divergencia"
    }
    data.frame(base = b, coluna = v, situacao = situacao,
               n_distintos = length(obs),
               n_fora = length(fora),
               fora = paste(head(fora, 10), collapse = " | "))
  }))
}))

row.names(auditoria) <- NULL
write.csv(auditoria, "data-raw/auditoria_metadados.csv", row.names = FALSE)

cat("Resumo da auditoria:\n")
print(table(auditoria$situacao))
cat("\nRevisar manualmente (divergencia):\n")
print(auditoria[auditoria$situacao == "divergencia",
                c("base", "coluna", "n_fora", "fora")], row.names = FALSE)
