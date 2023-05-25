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
names(fontes) <- c("cod", "desc", "dt_inicio_vigencia", "dt_fim_vigencia")

fontes[dt_fim_vigencia == "2023-00", dt_fim_vigencia := "9999-12"]

fontes$cod <- as.integer(fontes$cod)

fontes <- data.frame(cod = c(10L, 20L, 60L), 
                     desc = c("Recursos Ordinarios", "Recursos Vinculados", "Recursos Diretamente Arrecadados"),
                     dt_inicio_vigencia = "2002-00",
                     dt_fim_vigencia = "9999-12")

fontes |>
  dplyr::group_by(cod) |>
  dplyr::group_split() |>
  purrr::walk(~{
    file_name <- paste0("classificador/fonte-recurso/", formatC(.$cod[1], width = 2, flag = "0"), ".yml")
    yaml::write_yaml(., file_name, column.major = FALSE, indent.mapping.sequence = TRUE)
  })

