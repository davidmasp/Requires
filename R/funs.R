

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
  #p1 = "(?<=[:punct:])[:alnum:]+(?=::)" #!base::is.na()
  # one below shouls also capture this
  p2 = "(?<=[\\?|\\!])[:graph:]+(?=::)" #!test.test::is.na()
  p3 = "(?<=[:blank:])[:graph:]+(?=::)" #
  p4 = "^[:graph:]+(?=::)"

  lines %>% purrr::map(function(x){
    #d1 = stringr::str_extract_all(string = x,pattern = p1,simplify = TRUE)
    d2 = stringr::str_extract_all(string = x,pattern = p2,simplify = TRUE)
    d3 = stringr::str_extract_all(string = x,pattern = p3,simplify = TRUE)
    d4 = stringr::str_extract_all(string = x,pattern = p4,simplify = TRUE)

    candidates = c(#d1,
                   d2,
                   d3,
                   d4)

    candidates = candidates[!is.na(candidates) & nchar(candidates) != 0]
    if (length(candidates)!=1){
      mssg = glue::glue("More than one package per line, check if okay:
                 {candidates}
                        ")
      warning(mssg)
    }

    return(candidates)
  }) %>% unlist() -> candidates

  return(candidates)
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
