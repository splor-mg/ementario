library(execucao); library(relatorios); library(data.table); library(yaml)

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

