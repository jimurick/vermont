

mySelectInput <- function(...) {
  args <- list(...)
  x <- do.call(selectInput, args)
  htmltools::tagQuery(x)$
    addAttrs(style = "display: table-row; width: 5rem;")$
    find("label")$
    addAttrs(style = "display: table-cell; vertical-align: middle; text-align: left; width: 8rem;")$
    resetSelected()$
    find("div select")$
    addAttrs(style = "width: 5rem;")$
    allTags()
}


