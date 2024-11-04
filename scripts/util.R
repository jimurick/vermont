GH_URL <- "https://github.com/jimurick/vermont"

repo_url <- function(gh_path) {
  stringr::str_c(GH_URL, "/tree/main/", gh_path)
}

repo_link <- function(label, repo_path) {
  shiny::a(label, href = repo_url(repo_path))
}
