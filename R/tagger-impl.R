#' @noRd
tagger_impl <- function(functions) {
  function(sentence, join = TRUE, format = c("list", "data.frame"), sys_dic = "", user_dic = "", split = TRUE) {
    if (typeof(sentence) != "character") {
      if (typeof(sentence) == "factor") {
        stop("The type of input sentence is a factor. Please typesetting it with as.character().")
      } else {
        stop("The function gets a character vector only.")
      }
    }
    if (is_blank(sys_dic) && .Platform$OS.type == "windows") {
      sys_dic <- getWinDicDir(Sys.getenv("MECAB_LANG"))
    }
    if (!is_blank(getOption("mecabSysDic"))) {
      sys_dic <- getOption("mecaSysDic")
    }
    if (!is_blank(getOption("mecabSplit"))) split <- as.logical(getOption("mecabSplit"))

    # keep names
    nm <- names(sentence)
    if (identical(nm, NULL)) {
      nm <- seq_along(sentence)
    }
    sentence <- stringi::stri_enc_toutf8(sentence) %>%
      purrr::set_names(nm)

    format <- rlang::arg_match(format)
    sys_dic <- paste0(sys_dic, collapse = "")
    user_dic <- paste0(user_dic, collapse = "")

    if (format == "data.frame") {
      result <-
        purrr::imap_dfr(sentence, function(vec, doc_id) {
          if (identical(split, TRUE)) {
            vec <- stringi::stri_split_boundaries(vec, type = "sentence") %>%
              unlist()
          }
          dplyr::bind_cols(
            data.frame(doc_id = doc_id),
            functions$df(vec, sys_dic, user_dic)
          )
        }) %>%
        dplyr::mutate_if(is.character, ~ reset_encoding(.)) %>%
        dplyr::mutate_if(is.character, ~ dplyr::na_if(., "*")) %>%
        dplyr::mutate(
          doc_id = as.factor(.data$doc_id),
          sentence_id = as.factor(.data$sentence_id)
        )
    } else {
      if (join == TRUE) {
        result <-
          functions$join(sentence, sys_dic, user_dic) %>%
          purrr::map(reset_encoding) %>%
          purrr::set_names(nm)
      } else {
        result <-
          functions$base(sentence, sys_dic, user_dic) %>%
          purrr::map(function(elem) {
            names(elem) <- reset_encoding(names(elem))
            reset_encoding(elem)
          }) %>%
          purrr::set_names(nm)
      }
    }
    return(result)
  }
}
