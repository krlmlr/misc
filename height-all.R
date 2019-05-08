library(htmltools)

tagAppendAttributesAll <- function(x, ...) {
  if (!is.list(x)) return(NULL)
  if (inherits(x, "shiny.tag.list")) {
    x[] <- purrr::map(x[], tagAppendAttributesAll, ...)
    x
  } else {
    x <- tagSetChildren(
      x,
      list = purrr::map(x$children[], tagAppendAttributesAll, ...)
    )
    tagAppendAttributes(x, ...)
  }
}

tagSetFullHeightAll <- function(x) {
  tagAppendAttributesAll(x, style = "height: 100%;")
}

print(tagSetFullHeightAll(
  div(
    div(
      div("test"),
      style = "height: 400px; "
    )
  )
))
