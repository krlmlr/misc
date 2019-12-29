search_1 <- gh::gh("/search/repositories", .limit = 100, q = "is:public archived:none fork:none user:krlmlr")

search_1$items %>%
  purrr::map_chr("name") %>%
  writeLines("repos.txt")
