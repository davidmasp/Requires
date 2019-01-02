# install funs

install_requires_fromCran <- function(prefix,...){
  fn = glue::glue("{prefix}_cran.txt")
  install.packages(pkgs = readr::read_lines(fn),
                   ...)
}

install_requires_fromBioc <- function(prefix,...){
  fn = glue::glue("{prefix}_bioc.txt")
  BiocManager::install(pkgs = readr::read_lines(fn),
                   version = "3.8", ...)
}

install_requires_fromGithub <- function(prefix,...){
  fn = glue::glue("{prefix}_github.txt")
  devtools::install_github(pkgs = readr::read_lines(fn),
                       version = "3.8", ...)
}

