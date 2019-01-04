
get_deps_lib <- function(lines){
  dep1 = lines %>% purrr::map(stringr::str_extract,
                              pattern = "(?<=library\\()[:alnum:]+(?=\\))") %>%
    purrr::keep(~!is.na(.)) %>%
    unlist() %>%
    unique()

  return(dep1)
}
#library(VariantAnnotation)
#library(jhdfbdjhb)
get_deps_colon <- function(lines){
  dep2 = lines %>% purrr::map(stringr::str_extract,
                              pattern = "(?<=[:punct:])[:alnum:]+(?=::)") %>%
    purrr::keep(~!is.na(.)) %>%
    unlist() %>%
    unique()

  dep3 = lines %>% purrr::map(stringr::str_extract,
                              pattern = "(?<=[:blank:])[:alnum:]+(?=::)") %>%
    purrr::keep(~!is.na(.)) %>%
    unlist() %>%
    unique()
  return(c(dep2,dep3))
}

#' Get dependencies
#'
#' @param file a string character with the path for a R script file
#'
#' @return
#'
#' a character vector with dependencies
#'
#' @export
#'
#' @examples
get_deps <- function(file){
  lines = readLines(file)

  dependencies = c(get_deps_lib(lines),
                   get_deps_colon(lines))

  return(dependencies)
}
