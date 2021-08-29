#' @noRd
#' @keywords internal
tagger_impl <- function(functions) {
  function(sentence, join = TRUE, format = c("list", "data.frame"), sys_dic = "", user_dic = "") {
    if (typeof(sentence) != "character") {
      if (typeof(sentence) == "factor") {
        stop("The type of input sentence is a factor. Please typesetting it with as.character().")
      } else {
        stop("The function gets a character vector only.")
      }
    }
    if (!is_blank(getOption("mecabSysDic"))) sys_dic <- getOption("mecabSysDic")

    sentence <- stri_enc_toutf8(sentence)

    format <- match.arg(format)
    sys_dic <- paste0(sys_dic, collapse = "")
    user_dic <- paste0(user_dic, collapse = "")

    if (format == "data.frame") {
      result <-
        functions$df(sentence, sys_dic, user_dic) %>%
        mutate(across(where(is.character), ~ reset_encoding(.))) %>%
        mutate(across(where(is.character), ~ na_if(., "*"))) %>%
        mutate(doc_id = as.factor(doc_id))
    } else {
      if (join == TRUE) {
        result <-
          functions$join(sentence, sys_dic, user_dic) %>%
          lapply(reset_encoding) %>%
          set_names(sentence)
      } else {
        result <-
          functions$base(sentence, sys_dic, user_dic) %>%
          lapply(function(elem) {
            names(elem) <- reset_encoding(names(elem))
            reset_encoding(elem)
          }) %>%
          set_names(sentence)
      }
    }
    return(result)
  }
}
