data <- yaml::yaml.load_file("classificador/fonteRecurso/data.yaml") |> data.table::rbindlist()
data.table::fwrite(data, "data/fonte_recurso.csv")
