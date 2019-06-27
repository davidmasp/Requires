

remove_comented_lines <- function(lines){
  lines %>% stringr::str_split("#") %>% purrr::map_chr(1)
}

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
get_deps <- function(path = ".",
                     filename = NULL,
                     glob = "*.R",
                     recursive = TRUE,
                     inComments = FALSE){
  # this should make this work with single and multiple files, basically
  # the glob is simply the file name.

  # fs::dir_ls(regexp = utils::glob2rx("R/*.R"),
  #            recursive = TRUE)
  if (is.null(filename)){
    files = fs::dir_ls(path = path,
                       glob = glob,
                       recursive = recursive)
  } else {
    files <- file.path(path, filename)
  }

  lines = purrr::map(files,readLines) %>%
    magrittr::set_names(NULL) %>%
    unlist()
  # should I mantain files separated?

  if (!inComments){
    lines = remove_comented_lines(lines)
  }

  dependencies = c(get_deps_lib(lines),
                   get_deps_colon(lines))

  return(dependencies)
}
