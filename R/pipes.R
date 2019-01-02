# pipes


make_require <- function(file,
                    prefix="require",
                    path = ".",
                    mode="simple",
                    priorities = c("cran","bioc","github")){
  vec = get_deps(file = file)
  pkg_df = locate_pkg(pkg_vec = vec)
  write_requires(pkg_df = pkg_df,
                 prefix = prefix,
                 path = path,
                 mode = mode,
                 priorities = priorities)

}