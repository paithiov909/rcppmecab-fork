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
  if (!is.list(x) && length(x) <= 1) {
    if (is.null(x)) {
      return(TRUE)
    }
    dplyr::case_when(
      is.na(x) ~ TRUE,
      is.nan(x) ~ TRUE,
      is.character(x) && nchar(ifelse(trim, stringi::stri_trim(x), x)) == 0 ~ TRUE,
      TRUE ~ FALSE
    )
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, isBlank, trim = trim, ...)
  }
}

#' Alias of `isBlank`
#' @noRd
#' @export
is_blank <- isBlank

#' Format Character Vector
#' @noRd
#' @keywords internal
reset_encoding <- function(vec, enc = "UTF-8") {
  purrr::map_chr(vec, function(elem) {
    Encoding(elem) <- enc
    return(elem)
  })
}

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
