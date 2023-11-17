# RcppMeCab 0.1.0

+ As of v0.1.0, this fork has been changed to wrap the 'gibasa' package, instead of wrapping the 'MeCab' API via 'Rcpp' by itself. If you need the old version, use [paithiov909/RcppMeCab at v0.0.x branch](https://github.com/paithiov909/RcppMeCab/tree/v0.0.x).

# RcppMeCab 0.0.5

+ For performance, `tagger_impl` now skips resetting the output encodings to UTF-8.

# RcppMeCab 0.0.3

+ Refactored `isBlank` function.

# RcppMeCab 0.0.2

+ When `format="data.frame"`, the function returns 'doc_id' and 'sentence_id' as factors.
+ When `format="data.frame"` the function splits and flattens character vector into sentences with `stringi::stri_split_boundaries(type = "sentence")` before analyze them.
  + If `options(mecabSplit = FALSE)`, this behavior is skipped.
+ Fixed the behavior when input sentence is an unnamed vector.
+ Refactored C++ source for performance.
+ Included MeCab source code in package src directory for installation.

# RcppMeCab 0.0.1.3

+ Add analytic forms of conjugated morphemes when `format="data.frame"`
+ A bug fixed: Even when the features of system dictionary is less than 7, `format="data.frame"` works properly.

# RcppMeCab 0.0.1.2

+ loop version of `pos` function is fixed (duplicated result)
+ `sys_dic` is now working properly
+ each function checks `getOption("mecabSysDic")` to get user preference of MeCab system dictionary
+ present input character vecters over the result list attributes (names)
+ a single character vector input in `pos()` will return a list
+ an option for result type is added: with arg `format="data.frame"`

# RcppMeCab 0.0.1.1

+ `posParallel` function is added to support parallelization
+ `join` parameter is added to yield a output of morphemes only
+ `RcppParallel` dependency
+ `user_dic` parameter is added to support user dictionary usage
+ Published on CRAN

# RcppMeCab 0.0.1.0

+ First release
+ Windows support is solved; further work should be done for multiarch installation
