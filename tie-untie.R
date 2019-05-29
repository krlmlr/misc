library(tidyverse)

tie <- function(data, ..., .key = "data") {
  key_var <- rlang::as_string(rlang::ensym(.key))

  tie_vars <- unname(tidyselect::vars_select(names(data), ...))
  if (rlang::is_empty(tie_vars)) {
    tie_vars <- names(data)
  }

  if (dplyr::is_grouped_df(data)) {
    group_vars <- dplyr::group_vars(data)
  } else {
    group_vars <- setdiff(names(data), tie_vars)
  }
  tie_vars <- setdiff(tie_vars, group_vars)

  data <- dplyr::ungroup(data)
  if (rlang::is_empty(group_vars)) {
    return(tibble::tibble(!! key_var := data))
  }

  out <- dplyr::select(data, !!! rlang::syms(group_vars))
  out[[key_var]] <-   tied <- dplyr::select(data, !!! rlang::syms(tie_vars))
  out
}

untie <- function(data, ...) {
  quos <- rlang::quos(...)
  if (rlang::is_empty(quos)) {
    list_cols <- names(data)[purrr::map_lgl(data, rlang::is_list)]
    quos <- rlang::syms(list_cols)
  }

  if (length(quos) == 0) {
    return(data)
  }

  tied <- as.list(dplyr::transmute(data, !!! quos))

  group_vars <- setdiff(names(data), names(tied))

  rest <- dplyr::select(data, !!!rlang::syms(group_vars))
  dplyr::bind_cols(rest, tied)
}

as_tibble(iris) %>%
  tie(starts_with("Sepal"), .key = "Sepal") %>%
  tie(starts_with("Petal"), .key = "Petal") %>%
  tie(-Species)

as_tibble(iris) %>%
  tie(starts_with("Sepal"), .key = "Sepal") %>%
  tie(starts_with("Petal"), .key = "Petal") %>%
  tie(-Species) %>%
  head() %>%
  unclass()
