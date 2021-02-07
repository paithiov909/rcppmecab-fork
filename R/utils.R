#' Check if scalars are blank
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for \code{base::sapply()}.
#'
#' @return Logical values.
#'
#' @export
isBlank <- function(x, trim = TRUE, ...) {
  if (!is.list(x) && length(x) <= 1) {
    if (is.null(x)) {
      return(TRUE)
    }
    dplyr::case_when(
      is.na(x) ~ TRUE,
      is.nan(x) ~ TRUE,
      is.character(x) && nchar(ifelse(trim, stringr::str_trim(x), x)) == 0 ~ TRUE,
      TRUE ~ FALSE
    )
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, isBlank, trim = trim, ...)
  }
}

#' Check if dynamic libraries are available
#'
#' @param dynlib The names of dynamic libraries to check their accessibility. Default value is `libmecab`.
#' @return Logical.
#'
#' @export
isDynAvailable <- function(dynlib = "libmecab") {
  return(!isBlank(Sys.which(paste0(dynlib, .Platform$dynlib.ext))))
}
