library(tidyverse)

x <- tribble(
  ~Race,~Female_LoTR,~Male_LoTR,~Female_TT,~Male_TT,~Female_RoTK,~Male_RoTK,
  "Elf",        1229,       971,       331,     513,         183,       510,
  "Hobbit",       14,      3644,         0,    2463,           2,      2673,
  "Man",           0,      1995,       401,    3589,         268,      2459
)

xh <- tibble(
  Race = x$Race,
  Female = tibble(
    LoTR = x$Female_LoTR,
    TT = x$Female_TT,
    RoTK = x$Female_RoTK
  ),
  Male = tibble(
    LoTR = x$Male_LoTR,
    TT = x$Male_TT,
    RoTK = x$Male_RoTK
  )
)
xh

# Result of
# xh %>%
#   tie(Female, Male) %>%
#   mutate(.data = transpose_df(.data)) %>%
#   untie(.data)
# :
xht <- tibble(
  Race = x$Race,
  LoTR = tibble(
    Female = xh$Female$LoTR,
    Male = xh$Male$LoTR
  ),
  TT = tibble(
    Female = xh$Female$TT,
    Male = xh$Male$TT
  ),
  RoTK = tibble(
    Female = xh$Female$RoTK,
    Male = xh$Male$RoTK
  )
)
xht
