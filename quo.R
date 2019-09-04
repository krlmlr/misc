# Why is enquo() important?

library(rlang)
library(magrittr)

q <- function(...) {
  enquos(...)
}

e <- function(...) {
  enexprs(...)
}

qq <- function(...) {
  q <- enquos(...)
  lapply(q, eval_tidy)
}

ee <- function(...) {
  e <- enexprs(...)
  lapply(e, eval_tidy)
}

a <- 1
b <- 2

qq(a + b, a + 2, a + !!b, !!a + !!b)
ee(a + b, a + 2, a + !!b, !!a + !!b)

f <- function() {
  a <- 3
  b <- 4

  list(
    q = q(a + b, a + 2, a + !!b, !!a + !!b),
    e = e(a + b, a + 2, a + !!b, !!a + !!b),
    qq = qq(a + b, a + 2, a + !!b, !!a + !!b),
    ee = ee(a + b, a + 2, a + !!b, !!a + !!b)
  )
}

f()

lapply(f()$q, eval_tidy)
lapply(f()$e, eval_tidy)

q13 <- c(f()$q[1], f()$q[3])
lapply(q13, eval_tidy)

tibble::tibble(
  qq = qq(a + b, a + 2, a + !!b, !!a + !!b),
  ee = ee(a + b, a + 2, a + !!b, !!a + !!b)
)

# What does a quosure look like internally?

quo(a + b)

g <- function() {
  a <- 3
  b <- 4
  quo(a + !!iris)
}

g()

# Explicit and implicit access

Species <- "bla"

iris %>%
  dplyr::filter(Species == "setosa")

iris %>%
  dplyr::filter(.data$Species == "setosa")

iris %>%
  dplyr::filter(!!Species == "setosa")
