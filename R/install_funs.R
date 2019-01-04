# install funs

install_requires <- function(prefix,...){
  install_requires_from_cran(prefix,...)
  install_requires_from_bioc(prefix,...)
  install_requires_from_github(prefix,...)
}

install_requires_from_cran <- function(prefix,...){
  fn = glue::glue("{prefix}_cran.txt")
  install.packages(pkgs = readr::read_lines(fn),
                   ...)
}

install_requires_from_bioc <- function(prefix,...){
  fn = glue::glue("{prefix}_bioc.txt")
  BiocManager::install(pkgs = readr::read_lines(fn),
                   version = "3.8", ...)
}

install_requires_from_github <- function(prefix,...){
  fn = glue::glue("{prefix}_github.txt")
  devtools::install_github(pkgs = readr::read_lines(fn),
                       version = "3.8", ...)
}

