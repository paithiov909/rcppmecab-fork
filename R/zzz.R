#' @noRd
## usethis namespace: start
#' @import Rcpp
#' @importFrom RcppParallel RcppParallelLibs
#' @useDynLib RcppMeCab, .registration=TRUE
## --------------------------------------- ##
#' @importFrom rlang expr enquo enquos sym syms .data := as_name as_label
#' @importFrom dplyr %>%
## usethis namespace: end
NULL

#' @importFrom utils globalVariables
utils::globalVariables("where")

#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  # library.dynam.unload("RcppMeCab", libpath)
}
