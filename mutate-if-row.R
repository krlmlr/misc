library(tidyverse)

df <- tibble(a = 1:5)
df

if_flag <- function(quo, name) {
  rlang::quo_set_expr(
    quo,
    expr(if (.flag[1]) !!rlang::quo_get_expr(quo) else !!rlang::sym(name))
  )
}

mutate_if_row <- function(.data, cond, ...) {
  cond <- rlang::enquo(cond)
  quos <- rlang::quos(...)

  quos <- map2(quos, names(quos), if_flag)

  .data %>%
    group_by(.flag = !!cond) %>%
    mutate(!!!quos) %>%
    ungroup() %>%
    select(-.flag)
}

df %>%
  mutate_if_row(a > 3, a = a + 1L)
