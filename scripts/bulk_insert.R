library(execucao); library(relatorios); library(data.table); library(yaml)

data("exec_rec")
exec_rec <- exec_rec[, .N, .(ANO, MES_COD, FONTE_COD)]
exec_rec <- adiciona_desc(exec_rec)
exec_rec <- exec_rec[, valid_ref := paste(ANO, formatC(MES_COD, width = 2, flag = "0"), sep = "-")]
exec_rec <- exec_rec[, .(valid_ref, FONTE_COD, FONTE_DESC)]

data("loa_rec")
loa_rec <- loa_rec[, .N, .(ANO, FONTE_COD)]
loa_rec <- adiciona_desc(loa_rec)
loa_rec <- loa_rec[, valid_ref := paste(ANO, "00", sep = "-")]
loa_rec <- loa_rec[, .(valid_ref, FONTE_COD, FONTE_DESC)]

fontes <- rbind(exec_rec, loa_rec)
fontes <- fontes[, .(valid_from = min(valid_ref), valid_to = max(valid_ref)), by = .(FONTE_COD, FONTE_DESC)][order(FONTE_COD)]
names(fontes) <- c("cod", "desc", "valid_from", "valid_to")

fontes[valid_to == "2023-00", valid_to := "9999-12"]

fontes$cod <- as.integer(fontes$cod)

fontes[, seq := seq_len(.N) , cod]
setcolorder(fontes, c("cod", "seq", "desc", "valid_from", "valid_to"))

write_yaml(fontes, "classificador/fonteRecurso/data.yaml", column.major = FALSE, indent.mapping.sequence = TRUE)

