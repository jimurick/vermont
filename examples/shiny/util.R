

# https://unleash-shiny.rinterface.com/htmltools-overview#htmltools-modern

select_input_to_inline <- function(select_input, width1, width2) {
  wd <- sprintf("%drem", width1 + width2)
  wl <- sprintf("%drem", width1)
  ws <- sprintf("%drem", width2)
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

