read_yaml <- function(filepath, property) {
  data <- yaml::yaml.load_file(filepath)
  data <- data.table::rbindlist(data)
  data
}

data <- list.files(path = "classificador/fonte-recurso/", full.names = TRUE) |> 
        purrr::map(read_yaml) |> 
        data.table::rbindlist()

data.table::fwrite(data, "data/fonte-recurso-hist.csv")
data.table::fwrite(data[data$valid_to == "9999-12"], "data/fonte-recurso.csv")
