
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RcppMeCab

<!-- badges: start -->

[![RcppMeCab status
badge](https://paithiov909.r-universe.dev/badges/RcppMeCab)](https://paithiov909.r-universe.dev)
![GitHub](https://img.shields.io/github/license/paithiov909/RcppMeCab)
[![R-CMD-check](https://github.com/paithiov909/RcppMeCab/workflows/R-CMD-check/badge.svg)](https://github.com/paithiov909/RcppMeCab/actions)
<!-- badges: end -->

> This repo is a fork from
> [junhewk/RcppMeCab](https://github.com/junhewk/RcppMeCab)

This package, RcppMeCab, is an ‘Rcpp’ wrapper for the part-of-speech
morphological analyzer MeCab. It supports native utf-8 encoding in C++
code and CJK (Chinese, Japanese, and Korean) MeCab library. This package
fully utilizes the power Rcpp brings R computation to analyze texts
faster.

## Installation

``` r
# Enable repository from paithiov909
options(repos = c(
  paithiov909 = "https://paithiov909.r-universe.dev",
  CRAN = "https://cloud.r-project.org"))

# Download and install gibasa in R
install.packages("RcppMeCab")

# Or build from source package
Sys.setenv(MECAB_DEFAULT_RC = "/fullpath/to/your/mecabrc") # if necessary
remotes::install_github("paithiov909/RcppMeCab")
```

To use this package requires the MeCab library and its dictionary
installed and available.

In case using Linux or OSX, you can install them with their package
managers, or build and install from the source by yourself.

In case using Windows, use installer [built for
32bit](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7WElGUGt6ejlpVXc)
or [built for
64bit](https://github.com/ikegami-yukino/mecab/releases/tag/v0.996.2).

## Usage

This package has `pos` and `posParallel` function.

``` r
sentence <- "雨にも負けず、風にも負けず"

## テキストだけ与える場合、デフォルトの戻り値はnamed list of character vectors.
## リストの各要素は、表層形（surface form）と素性情報の1番目（IPA辞書では「品詞」）を'/'で区切ってつなげた文字列ベクトルになる。
pos(sentence) # returns list
#> $`1`
#>  [1] "雨/名詞"   "に/助詞"   "も/助詞"   "負け/動詞" "ず/助動詞" "、/記号"  
#>  [7] "風/名詞"   "に/助詞"   "も/助詞"   "負け/動詞" "ず/助動詞"

## 'join = FALSE'を指定すると、戻り値はnamed list of named character vectorsになる。
## Neologd辞書などでは収録されている語彙そのものに'/'が含まれていることがあるため、使用ケースによって使い分けるとよい。
pos(sentence, join = FALSE) # for yielding morphemes only (tags will be given on the vector names)
#> $`1`
#>   名詞   助詞   助詞   動詞 助動詞   記号   名詞   助詞   助詞   動詞 助動詞 
#>   "雨"   "に"   "も" "負け"   "ず"   "、"   "風"   "に"   "も" "負け"   "ず"

## 'format = data.frame'にすると、戻り値は以下のようなデータフレームになる。
## pos列・subtype列は素性情報の1~2番目（IPA辞書では「品詞」と「品詞細分類1」）、
## analytic列は素性情報の8番目（IPA辞書の「読み」）だが、
## 未知語で推定されない素性だった場合などには'NA_character_'が含まれることがある。
pos(sentence, format = "data.frame") # the result will returned as a data frame format
#>    doc_id sentence_id token_id token    pos subtype analytic
#> 1       1           1        1    雨   名詞    一般     アメ
#> 2       1           1        2    に   助詞  格助詞       ニ
#> 3       1           1        3    も   助詞  係助詞       モ
#> 4       1           1        4  負け   動詞    自立     マケ
#> 5       1           1        5    ず 助動詞    <NA>       ズ
#> 6       1           1        6    、   記号    読点       、
#> 7       1           1        7    風   名詞    一般     カゼ
#> 8       1           1        8    に   助詞  格助詞       ニ
#> 9       1           1        9    も   助詞  係助詞       モ
#> 10      1           1       10  負け   動詞    自立     マケ
#> 11      1           1       11    ず 助動詞    <NA>       ズ

posParallel(sentence) # parallelized version uses more memory, but much faster than the loop in single threading
#> $`1`
#>  [1] "雨/名詞"   "に/助詞"   "も/助詞"   "負け/動詞" "ず/助動詞" "、/記号"  
#>  [7] "風/名詞"   "に/助詞"   "も/助詞"   "負け/動詞" "ず/助動詞"
```

both two funtions can get same arguments:

- sentence: a text for analyzing
- join: If it gets TRUE, output form is (morpheme/tag). If it gets
  FALSE, output form is (morpheme) + tag in attribute.
- format: The default is a list. If you set this as `"data.frame"`, the
  function will return the result in a data frame format.
- sys_dic: a directory in which `dicrc` file is located, default value
  is `NULL` or you can set your default value using
  `options(mecabSysDic = "/path/to/your/system_dictionary")`
- user_dic: a user dictionary file compiled by `mecab_dict_index`,
  default value is also “”

## License

GPL (\>=3)
