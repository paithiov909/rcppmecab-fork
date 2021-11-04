#' @noRd
#' @keywords internal
getWinDicDir <- function(lang) {
  ifelse(identical(lang, "ja"),
         "C:/PROGRA~2/mecab/dic/ipadic",
         "C:/mecab/mecab-ko-dic")
}

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
  purrr::map_chr(vec, function(elem) {
    Encoding(elem) <- enc
    return(elem)
  })
}

#' Pack Output of POS Tagger
#'
#' @param df Output of \code{pos(format = "data.frame")} or \code{posParallel(format = "data.frame")}.
#' @param pull Column name to be packed into data.frame. Default value is `token`.
#' @param .collapse This argument is passed to \code{stringi::stri_c()}.
#' @return data.frame
#'
#' @export
pack <- function(df, pull = "token", .collapse = " ") {
  res <- df %>%
    dplyr::group_by(.data$doc_id) %>%
    dplyr::group_map(
      ~ dplyr::pull(.x, {{ pull }}) %>%
        stringi::stri_c(collapse = .collapse)
    ) %>%
    purrr::imap_dfr(~ data.frame(doc_id = .y, text = .x))
  return(res)
}
