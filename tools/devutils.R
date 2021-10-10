#' Util for testing
is_win_running_on_ci <- function() {
  return(testthat:::on_ci() && .Platform$OS.type == "windows")
}

#' Util for local build and install under Windows machine
set_mecab_libs <- function(mecab_libs = "/mecab") {
  # UNIX sytle path separator should be used in MECAB_LIBS.
  # See `?file.path` about path separator.
  libmecab_path <- file.path(mecab_libs, fsep = "/")
  if (.Platform$OS.type == "windows") {
    Sys.setenv("MECAB_LIBS" = libmecab_path)
  }
  return(Sys.getenv("MECAB_LIBS"))
}

#' Util for using Korean mecab
set_env_ko <- function(sysdic = "C:/mecab/mecab-ko-dic") {
  Sys.setenv("MECAB_LANG" = "ko")
  options("mecabSysDic" = file.path(sysdic))
  return(invisible(file.path(sysdic)))
}

#' Util for using Japanese mecab
set_env_ja <- function(sysdic = "C:/PROGRA~2/mecab/dic/ipadic") {
  Sys.setenv("MECAB_LANG" = "ja")
  options("mecabSysDic" = file.path(sysdic))
  return(invisible(file.path(sysdic)))
}
