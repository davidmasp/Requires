# fucntions to see where the packages are


locate_pkg <- function(pkg_vec){
  purrr::map_df(pkg_vec,function(x){
    cran = !as.logical(available::available_on_cran(x))
    bioc = !as.logical(available::available_on_bioc(x))
    github = !as.logical(available::available_on_github(x)$available)

    version =  packageVersion(x)

    data.frame(name = x,
               cran = cran,
               bioc = bioc,
               github = github,
               version = as.character(version))
  })
}


write_requires_simple <- function(pkg_df,prefix,priorities){

  sel = apply(res[,priorities], 1, function(y){min(which(y))})

  for (i in 1:length(priorities)){
    vec = pkg_df[sel == i,"name"]
    if (length(vec) != 0){
      readr::write_lines(x = vec,
                         path = glue::glue("{prefix}_{priorities[i]}.txt"))
    }
  }
}

write_requires_csv <- function(pkg_df,prefix,path){
  readr::write_csv(x = pkg_df,
                   path = fs::path(path,prefix,ext = "csv"))
}

write_requires <- function(pkg_df,
                           prefix="require",
                           path = ".",
                           mode="simple",
                           priorities = c("cran","bioc","github")){
  switch (mode,
    simple = {write_requires_simple(pkg_df,prefix,priorities)},
    csv = {write_requires_csv(pkg_df,prefix,path)}
  )
}


# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("stringr", version = "3.8")