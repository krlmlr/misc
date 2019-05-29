library(tidyverse)

nest_column <- function(data, ..., .key = "data") {
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

unnest_column <- function(data, ...) {
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

spread <- function(data, key, ...) {
  key <- rlang::enquo(key)

  df_var <- names(data)[purrr::map_lgl(data, is.data.frame)]
  rest_var <- setdiff(names(data), c(df_var, rlang::as_name(key)))

  data <- split(dplyr::select(data, -!!key), dplyr::pull(data, !!key))

  browser()

  # TODO
  overall <- purrr::map(data, rest_var)
  overall <- sort(unique(unlist(overall)))

  data <- purrr::imap(data, function(d, nm) {
    res <- vctrs::vec_slice(d[[df_var]], match(overall, d[[rest_var]], nomatch = NA))
    #names(res) <- paste(nm, names(res), sep = "_")
    res
  })

  ret <- tibble::tibble(!! rest_var := overall)
  ret[names(data)] <- data
  ret
}

data <- tibble::tribble(
  ~hw,   ~name,  ~mark,   ~pr,
  "hw1", "anna",    95,  "ok",
  "hw1", "alan",    90, "meh",
  "hw1", "carl",    85,  "ok",
  "hw2", "alan",    70, "meh",
  "hw2", "carl",    80,  "ok"
)

g <-
  data %>%
  group_by(hw, name) %>%
  group_data() %>%
  mutate(.rows = unlist(.rows)) %>%
  complete(hw, name) %>%
  nest(-hw)

tibble_ <- function(x) tibble(!!!x)

g %>%
  mutate(data = map(data, deframe)) %>%
  mutate(data = map(data, tibble_)) %>%
  unnest()


asdf
  group_by(hw) %>%
  summarize(data = list(enframe(setNames(.rows, name)))) %>%
  unnest()


data %>%
  spread(pr, mark)

data %>%
  nest_column(mark, pr) %>%
  tidyr::spread(hw, data) %>%
  unnest_column()
