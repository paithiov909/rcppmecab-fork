#' @noRd
#' @keywords internal
resetEncoding <- function(chr, encoding = "UTF-8") {
  Encoding(chr) <- encoding
  return(chr)
}

#' Yet another part-of-speech tagger
#'
#' @param sentence Character vector.
#' @param into Character vector.
#' @param sys_dic A location of system MeCab dictionary. The default value is "".
#' @param user_dic A location of user-specific MeCab dictionary. The default value is "".
#' @return data.frame
#'
#' @export
posSimple <- function(sentence,
                      into = c(
                        "POS1",
                        "POS2",
                        "POS3",
                        "POS4",
                        "X5StageUse1",
                        "X5StageUse2",
                        "Original",
                        "Yomi1",
                        "Yomi2"
                      ),
                      sys_dic = "",
                      user_dic = "") {
  if (typeof(sentence) != "character") {
    if (typeof(sentence) == "factor") {
      stop("The type of input sentence is a factor. Please typesetting it with as.character().")
    } else {
      stop("The function gets a character vector only.")
    }
  }

  if (!is.null(getOption("mecabSysDic")) && !sys_dic == "") sys_dic = getOption("mecabSysDic")

  sentence <- stringi::stri_enc_toutf8(sentence)
  sys_dic <- paste0(sys_dic, collapse = "")
  user_dic <- paste0(user_dic, collapse = "")

  result <- posApplyDFRcpp(sentence, sys_dic, user_dic)
  result <- result %>%
    purrr::imap_dfr(~ data.frame(sentence_id = .y, .x)) %>%
    dplyr::mutate(dplyr::across(where(is.character), ~ resetEncoding(.))) %>%
    tidyr::separate(
      col = "Feature",
      into = into,
      sep = ",",
      fill = "right"
    ) %>%
    dplyr::mutate(dplyr::across(where(is.character), ~ dplyr::na_if(., "*")))

  return(result)
}
