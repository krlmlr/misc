library(tidyverse)
x <- readRDS("tibble.rds")

requireNamespace("revdepcheck")

`rcmdcheck_status.try-error` <- function(...) "i"

rcmdcheck_status.NULL <- function(...) "i"

fail <- map_lgl(x, inherits, "try-error") | map_lgl(x, is.null)

names(x[fail])

x[fail] <-
  map(names(x[fail],

  list(
  rcmdcheck:::rcmdcheck_comparison(
    old = rcmdcheck:::new_rcmdcheck("Install failed", "", description = desc::description$new()),
    new = rcmdcheck:::new_rcmdcheck("Install failed", "", description = "")
  )
)

status <- vapply(x, revdepcheck:::rcmdcheck_status, character(1), USE.NAMES = FALSE)

revdepcheck::revdep_email("failed", results = x)

length(x)
