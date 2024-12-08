
# By default, shiny's `selectInput()` widget will put the label above the
# <select>, while I often prefer to have both on the same line.
#
# This function fixes that using the `htmltools::tagQuery()` function to
# chain together modifications to the widget's HTML. Its syntax is similar to
# chaining together dplyr functions with the pipe operator `|>`, except with
# the "extract operator" `$`.
#
# See Outstanding User Interfaces with Shiny:
# https://unleash-shiny.rinterface.com/htmltools-overview#htmltools-modern

select_input_to_inline <- function(select_input, label_width, select_width) {
  wd <- sprintf("%drem", label_width + select_width)
  wl <- sprintf("%drem", label_width)
  ws <- sprintf("%drem", select_width)
  # There are 3 HTML elements that I want to add a style attribute to: a <div>,
  # a <label> and a <select>. 
  div_style <- stringr::str_interp("display: table-row; width: ${wd};")
  label_style <- stringr::str_interp("
    display: table-cell; vertical-align: middle; text-align: left; width: ${wl};
  ")
  select_style <- stringr::str_interp("width: ${ws};")
  
  htmltools::tagQuery(select_input)$
    addAttrs(style = div_style)$
    find("label")$
    addAttrs(style = label_style)$
    resetSelected()$
    find("div select")$
    addAttrs(style = select_style)$
    allTags()
}

