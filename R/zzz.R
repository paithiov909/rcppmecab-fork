#' @noRd
## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib RcppMeCab, .registration=TRUE
## usethis namespace: end
NULL

#' @noRd
#' @keywords internal
getWinDicDir <- function(lang) {
  ifelse(identical(lang, "ja"),
         "C:/PROGRA~2/mecab/dic/ipadic",
         "C:/mecab/mecab-ko-dic")
}

#' @noRd
#' @param libpath libpath
.onUnload <- function(libpath) {
  library.dynam.unload("RcppMeCab", libpath)
}
