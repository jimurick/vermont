GH_URL <- "https://github.com/jimurick/vermont"

repo_url <- function(gh_path) {
  stringr::str_c(GH_URL, "/tree/main/", gh_path)
}

repo_link <- function(label, repo_path) {
  shiny::a(label, href = repo_url(repo_path))
}


image_preview_on_hover <- function(link_text, img_file, elt_id = NULL) {
  if (is.null(elt_id)) {
    elt_id <-
      stringr::str_replace_all(basename(img_file), "[^a-zA-Z0-9-]", '-')
  }
  if (file.exists(img_file)) {
    shiny::span(
      shiny::a(
        link_text, href = img_file,
        onpointerenter = stringr::str_interp("showImage('${elt_id}')"),
        onpointerleave = "hideImage()",
        style = "display: inline-block;"
      ),
      shiny::div(
        shiny::img(src = img_file),
        id = elt_id, class = "image-preview"
      ),
      style = "display: inline-block;"
    )
  } else {
    shiny::span(
      stringr::str_interp("File '${img_file}' does not exist!"),
      class = "error-text"
    )
  }
}

