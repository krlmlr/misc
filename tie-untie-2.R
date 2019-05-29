library(tidyverse)

data <- tribble(
  ~hw,   ~name,  ~mark,   ~pr,
  "hw1", "anna",    95,  "ok",
  "hw1", "alan",    90, "meh",
  "hw1", "carl",    85,  "ok",
  "hw2", "alan",    70, "meh",
  "hw2", "carl",    80,  "ok"
)

# tie
tied <- data
tied$data <- data %>% select(-hw, -name)
tied <- tied[c("hw", "name", "data")]
tied

# spread
spread <- tibble(
  hw = unique(tied$hw),
  anna = tied$data[tied$name == "anna", ][1:2, ],
  alan = tied$data[tied$name == "alan", ][1:2, ],
  carl = tied$data[tied$name == "carl", ][1:2, ]
)
spread

# untie: omitted, straightforward


library(tidyverse)

x <- tribble(
  ~Race,~Female_LoTR,~Male_LoTR,~Female_TT,~Male_TT,~Female_RoTK,~Male_RoTK,
  "Elf",        1229,       971,       331,     513,         183,       510,
  "Hobbit",       14,      3644,         0,    2463,           2,      2673,
  "Man",           0,      1995,       401,    3589,         268,      2459
)

# Result of hierarchize(x, sep = "_"):
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

# Result of gathering:
tibble(
  Race = c(xh$Race, xh$Race),
  key = c(rep("Female", 3), rep("Male", 3)),
  value = tibble(
    LoTR = c(xh$Female$LoTR, xh$Male$LoTR),
    TT = c(xh$Female$TT, xh$Male$TT),
    RoTK = c(xh$Female$RoTK, xh$Male$RoTK)
  )
)
