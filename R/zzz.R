#' @noRd
## usethis namespace: start
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @useDynLib RcppMeCab, .registration=TRUE
## --------------------------------------- ##
#' @import dplyr
## usethis namespace: end
NULL

#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppMeCab", libpath)
}
