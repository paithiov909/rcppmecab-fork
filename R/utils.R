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
    case_when(
      is.na(x) ~ TRUE,
      is.nan(x) ~ TRUE,
      is.character(x) && nchar(ifelse(trim, stri_trim(x), x)) == 0 ~ TRUE,
      TRUE ~ FALSE
    )
  } else {
    if (length(x) == 0) {
      return(TRUE)
    }
    sapply(x, isBlank, trim = trim, ...)
  }
}

#' @noRd
is_blank <- isBlank

#' Check if mecab or its dynamic libarary is available
#'
#' @return Logical.
#'
#' @keywords internal
#' @export
is_dyn_available <- function() {
  if (.Platform$OS.type == "windows") {
    return(!is_blank(Sys.which(paste0("libmecab", .Platform$dynlib.ext))))
  } else {
    return(!is_blank(Sys.which(paste0("mecab"))))
  }
}

#' Format Character Vector
#' @noRd
#' @keywords internal
reset_encoding <- function(vec, enc = "UTF-8") {
  sapply(vec, function(elem) {
    Encoding(elem) <- enc
    return(elem)
  }, USE.NAMES = FALSE)
}

#' Pack Output of POS Tagger
#'
#' @param df Output of \code{pos(format = "data.frame")} or \code{posParallel(format = "data.frame")}.
#' @param pull Column name to be packed into data.frame. Default value is `token`.
#' @param .collapse This argument will be passed to \code{stringi::stri_c()}.
#' @return data.frame
#'
#' @examples
#' \dontrun{
#' sentence <- c("some UTF-8 texts")
#' result <- pos(sentence, format = "data.frame")
#' pack(result)
#' }
#'
#' @export
pack <- function(df, pull = "token", .collapse = " ") {
  res <- df %>%
    group_by(doc_id) %>%
    group_map(
      ~ pull(.x, {{ pull }}) %>%
        stri_c(collapse = .collapse)
    ) %>%
    imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}
