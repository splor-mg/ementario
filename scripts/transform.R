read_yaml <- function(filepath) {
  data <- yaml::yaml.load_file(filepath)
  data <- data.table::rbindlist(data[["hist"]])
  metadata <- file.info(filepath)
  data$updated_at <- metadata[["mtime"]]
  data
}

data <- list.files(path = "content/fonte-recurso/", full.names = TRUE) |> 
        lapply(read_yaml) |> 
        data.table::rbindlist()

data.table::fwrite(data, "data/fonte-recurso.csv")
