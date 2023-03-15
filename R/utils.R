#' Check if scalars are blank
#'
#' @param x Object to check its emptiness.
#' @param trim Logical.
#' @param ... Additional arguments for \code{base::sapply()}.
#'
#' @return Logical values.
#'
#' @aliases is_blank
#' @export
isBlank <- function(x, trim = TRUE, ...) {
  if (!is.list(x)) {
    if (is.null(x)) {
      return(TRUE)
    }
    if (is.character(x) && trim) x <- stringi::stri_trim(x)
    is.blank(x)
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, isBlank, trim = trim, ...)
  }
}

is.blank <- function(x) {
  UseMethod("is.blank", x)
}

is.blank.default <- function(x) {
  is.na(x) | is.nan(x)
}

is.blank.character <- function(x) {
  is.na(x) | stringi::stri_isempty(x)
}

#' Alias of `isBlank`
#' @noRd
#' @export
is_blank <- isBlank

#' Pipe operator
#'
#' Reexported pipe originally from magrittr's pipe operator.
#'
#' @name %>%
#' @rdname pipe
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @export
NULL
