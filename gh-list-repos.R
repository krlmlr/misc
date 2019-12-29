search_1 <- gh::gh("/search/repositories", .limit = 100, q = "is:public archived:none fork:true user:krlmlr")

forks <-
  search_1$items %>%
  purrr::map_lgl("fork")

search_1$items[forks] %>%
  purrr::map_chr("name") %>%
  writeLines("repos.txt")
