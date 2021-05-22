#' @noRd
## usethis namespace: start
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @useDynLib RcppMeCab, .registration=TRUE
## --------------------------------------- ##
#' @import dplyr
#' @import purrr
#' @importFrom stringi stri_enc_toutf8
#' @importFrom stringr str_trim str_c
## usethis namespace: end
NULL

#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppMeCab", libpath)
}
