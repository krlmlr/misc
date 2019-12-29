repos <- readLines("repos.txt")

library(tidyverse)

walk(
  repos,
  ~ safely(gh::gh, quiet = FALSE)(.method = "DELETE", paste0("/repos/krlmlr/", .x))
)
