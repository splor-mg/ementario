library(execucao); library(relatorios); library(data.table); library(yaml)

bulk_insert <- function(classificacao, cod, desc) {
  data <- execucao::exec_rec[, .N, by = c("ANO", "MES_COD", cod)]
  data <- relatorios::adiciona_desc(data)
  data <- data[, valid_ref := paste(ANO, formatC(MES_COD, width = 2, flag = "0"), sep = "-")]
  
  data <- data[, .(valid_from = min(valid_ref), valid_to = max(valid_ref)), by = c(cod, desc)]
  
  names(data) <- c("cod", "desc", "valid_from", "valid_to")
  
  data[valid_to == "2023-00", valid_to := "9999-12"]
  
  data$cod <- as.integer(data$cod)
  
  data[, seq := seq_len(.N) , cod]
  data.table::setcolorder(data, c("cod", "seq", "desc", "valid_from", "valid_to"))
  
  write_yaml(data[order(cod, seq)], paste0("classificador/", classificacao, "/data.yaml"), column.major = FALSE, indent.mapping.sequence = TRUE)
}

bulk_insert("unidadeOrcamentaria", "UO_COD", "UO_SIGLA")
