read_yaml <- function(filepath, property) {
  data <- yaml::yaml.load_file(filepath)
  data <- data.table::rbindlist(data[[property]])
  data
}

data <- list.files(path = "content/fonte-recurso/", full.names = TRUE) |> 
        purrr::map(read_yaml, property = "hist") |> 
        data.table::rbindlist()

data.table::fwrite(data, "data/fonte-recurso-hist.csv")
data.table::fwrite(data[data$valid_to == '9999-12'], "data/fonte-recurso.csv")

data_mappings <- list.files(path = "content/fonte-recurso/", full.names = TRUE) |> 
  purrr::map(read_yaml, property = "mappings") |> 
  data.table::rbindlist(fill = TRUE)

data.table::fwrite(data_mappings, "data/fonte-recurso-mappings.csv")
