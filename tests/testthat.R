library(testthat)
library(RcppMeCab)
library(purrr)

#' Util for testing
is_win_running_on_ci <- function() {
  return(testthat:::on_ci() && .Platform$OS.type == "windows")
}
## TODO: tests on CRAN under Windows?
## These tests are currently skipped under Windows machines running on CI.
## This is because we have no way to ensure there is any MeCab dictionaries properly installed
## under these Windows machines.
test_check("RcppMeCab")
