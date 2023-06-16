data <- yaml::yaml.load_file("classificador/fonteRecurso/lookup.yaml") |> data.table::rbindlist()
data.table::fwrite(data, "data/fonte-recurso-temporal.csv")
data.table::fwrite(data[valid_to == "9999-12"], "data/fonte-recurso.csv")
