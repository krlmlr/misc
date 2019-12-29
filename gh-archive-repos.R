repos <- readLines("repos.txt")

library(tidyverse)

walk(
  repos,
  ~ safely(gh::gh, quiet = FALSE)(.method = "PATCH", paste0("/repos/krlmlr/", .x), archived = TRUE)
)
