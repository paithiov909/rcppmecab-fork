#' @noRd
## usethis namespace: start
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @useDynLib RcppMeCab, .registration=TRUE
## --------------------------------------- ##
#' @import dplyr
#' @import purrr
#' @importFrom stringi stri_omit_na stri_trim stri_c stri_split_boundaries
## usethis namespace: end
NULL

#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppMeCab", libpath)
}
