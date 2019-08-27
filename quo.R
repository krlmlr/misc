# Why is enquo() important?

library(rlang)

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
    qq = qq(a + b, a + 2, a + !!b, !!a + !!b),
    ee = ee(a + b, a + 2, a + !!b, !!a + !!b)
  )
}

f()

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
