#' parallel version of part-of-speech tagger
#'
#' \code{posParallel} returns part-of-speech (POS) tagged morphemes of the sentence.
#'
#' This is a parallelized version of MeCab part-of-speech tagger. The function gets a
#' character vector of any length and runs a loop inside C++ with Intel TBB to provide faster
#' processing.
#'
#' Parallelizing over a character vector is not supported by \code{RcppParallel}.
#' Thus, this function makes duplicates of the input and the output.
#' Therefore, if your data volume is large, use \code{pos} or divide the vector to
#' several sub-vectors.
#'
#' You can add a user dictionary to `user_dic`. It should be compiled by
#' `mecab-dict-index`. You can find an explanation about compiling a user
#' dictionary in the \url{https://github.com/junhewk/RcppMeCab}.
#'
#' You can also set a system dictionary especially if you are using multiple
#' dictionaries (for example, using both IPA and Juman dictionary at the same time in Japanese)
#' in `sys_dic`. Using \code{options(mecabSysDic="#the path to your system dictionary")}, you can set your
#' preferred system dictionary to the R terminal.
#'
#' If you want to get a morpheme only, use `join = FALSE` to put tag names on the attribute.
#' Basically, the function will return a list of character vectors with (morpheme)/(tag) elements.
#'
#' @param sentence A character vector of any length. For analyzing multiple sentences, put them in one character vector.
#' @param join A logical to decide the output format. The default value is TRUE. If FALSE, the function will return morphemes only, and tags put in the attribute. if `format="data.frame"`, then this will be ignored.
#' @param format A data type for the result. The default value is "list". You can set this to "data.frame" to get a result as data frame format.
#' @param sys_dic A location of system MeCab dictionary. The default value is "".
#' @param user_dic A location of user-specific MeCab dictionary. The default value is "".
#' @return A string vector of POS tagged morpheme will be returned in conjoined character
#'  vector form. Element names of the list are original phrases
#'
#' @examples
#' \dontrun{
#' sentence <- c("some UTF-8 texts")
#' posParallel(sentence)
#' posParallel(sentence, join = FALSE)
#' posParallel(sentence, format = "data.frame")
#' posParallel(sentence, user_dic = "~/user_dic.dic")
#' # System dictionary example: in case of using mecab-ipadic-NEologd
#' pos(sentence, sys_dic = "/usr/local/lib/mecab/dic/mecab-ipadic-neologd/")
#' }
#'
#' @export
posParallel <- function(sentence,
                        join = TRUE,
                        format = c("list", "data.frame"),
                        sys_dic = "",
                        user_dic = "") {
  format <- match.arg(format, choices = c("list", "data.frame"))
  into <- ifelse(
    Sys.getenv("MECAB_LANG") != "ja",
    list(gibasa::get_dict_features("ko-dic")),
    list(gibasa::get_dict_features("ipa"))
  )
  split <- ifelse(
    isTRUE(getOption("mecabSplit")),
    TRUE,
    FALSE
  )
  sys_dic <- ifelse(
    !is.null(getOption("mecabSysDic")),
    as.character(getOption("mecabSysDic")),
    ""
  )
  dat <- gibasa::tokenize(sentence, sys_dic = sys_dic, user_dic = user_dic, split = split)
  dat <- gibasa::prettify(dat, into = unlist(into), col_select = c(1, 2, 8))
  colnames(dat) <- c("doc_id", "sentence_id", "token_id", "token", "pos", "subtype", "analytic")

  if (format == "data.frame") {
    return(dat)
  } else {
    if (join) { dat$token <- paste(dat$token, dat$pos, sep = "/") }
    pos_field <- unlist(ifelse(join, list(NULL), list("pos")))
    gibasa::as_tokens(dat, pos_field = pos_field)
  }
}

#' Alias of `posParallel`
#' @inherit posParallel
#' @export
pos_parallel <- posParallel
