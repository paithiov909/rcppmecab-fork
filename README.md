# RcppMeCab

[![License](https://img.shields.io/badge/license-GPL-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl.html)
![R](https://img.shields.io/github/r-package/v/junhewk/RcppMeCab)
[![CRAN](http://www.r-pkg.org/badges/version/RcppMeCab)](https://cran.r-project.org/package=RcppMeCab)
[![Downloads](http://cranlogs.r-pkg.org/badges/RcppMeCab?color=brightgreen)](http://www.r-pkg.org/pkg/RcppMeCab)

This package, RcppMeCab, is an 'Rcpp' wrapper for the part-of-speech morphological analyzer MeCab. It supports native utf-8 encoding in C++ code and CJK (Chinese, Japanese, and Korean) MeCab library. This package fully utilizes the power Rcpp brings R computation to analyze texts faster.

__Please see [this](README_kr.md) for easy installation and usage examples in Korean.__

## Installation

### Linux and Mac OSX

First, __install MeCab of your language-of-choice__.

+ Japanese: MeCab from [GitHub](http://taku910.github.io/mecab/)
+ Korean: MeCab-Ko from [Bitbucket repository](https://bitbucket.org/eunjeon/mecab-ko)
+ Chinese: MeCab and MeCab Chinese Dic from [MeCab-Chinese](http://www.52nlp.cn/%E7%94%A8mecab%E6%89%93%E9%80%A0%E4%B8%80%E5%A5%97%E5%AE%9E%E7%94%A8%E7%9A%84%E4%B8%AD%E6%96%87%E5%88%86%E8%AF%8D%E7%B3%BB%E7%BB%9F%E4%B8%89%EF%BC%9Amecab-chinese)

Second, you can install RcppMeCab from CRAN with:

```r
install.packages("RcppMeCab")
```

### Windows

You should set the language you want to use for the analysis with the environment variable `MECAB_LANG`. If you want to analyze Japanese, please set it as `Sys.setenv(MECAB_LANG = 'ja')` before use the package.

```r
# install CRAN version for Korean
install.packages("RcppMeCab")
```

Currently, `MECAB_LANG='ja'` does not work properly on CRAN release. So, if you would like to use RcppMeCab with Japanese, please use the developmental version.

```r
# install developmental version from source
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("junhewk/RcppMeCab") 
```

For analyzing, you also need MeCab binary and dictionary.

Note that the MeCab library built for Windows does not have compatibility with both 32-bit R and 64-bit R. Because of this, if you build and install RcppMeCab from source package, it may be helpful you to use some build options that `--no-multiarch` and/or `--no-test-load`.

#### For Korean:

Install [mecab-ko-msvc](https://github.com/Pusnow/mecab-ko-msvc) and [mecab-ko-dic-msvc](https://github.com/Pusnow/mecab-ko-dic-msvc) up to your 32-bit or 64-bit Windows version in `C:\mecab`. Then, add that directory to the PATH environment variable, and provide dictionary location to RcppMeCab function.

#### For Japanese:

Install mecab binary [built for 32-bit](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7WElGUGt6ejlpVXc) and/or [built for 64-bit](https://github.com/ikegami-yukino/mecab/releases/tag/v0.996.2). Then, add the `C:\PROGRA~2\mecab\bin\` (32-bit) or `C:\PROGRA~1\mecab\bin` (64-bit) directory to the PATH environment variables, and provide dictionary location to RcppMeCab function if necessary.

## Usage

This package has `pos` and `posParallel` function.

```r
pos(sentence) # returns list, sentence will present on the names of the list
pos(sentence, join = FALSE) # for yielding morphemes only (tags will be given on the vector names)
pos(sentence, format = "data.frame") # the result will returned as a data frame format
pos(sentence, user_dic) # gets a compiled user dictionary 
posParallel(sentence, user_dic) # parallelized version uses more memory, but much faster than the loop in single threading
```

+ sentence: a text for analyzing
+ join: If it gets TRUE, output form is (morpheme/tag). If it gets FALSE, output form is (morpheme) + tag in attribute.
+ format: The default is a list. If you set this as `"data.frame"`, the function will return the result in a data frame format.
+ sys_dic: a directory in which `dicrc` file is located, default value is `NULL` or you can set your default value using `options(mecabSysDic = "/path/to/your/system_dictionary")` 
+ user_dic: a user dictionary file compiled by `mecab_dict_index`, default value is also ""

## Compiling User Dictionary

MeCab API has DictionaryCompiler, but it contains `die()`. Hence, calling it in Rcpp crashes down entire R session. This will not be included in RcppMeCab functions.

Please refer to [Mecab](http://taku910.github.io/mecab/dic.html) for Japanese.

### Unix and Mac OSX

You should have `model_file` if you want the library to estimate cost automatically. 

+ Japanese: [model_file in ipadic](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7bnc5aFZSTE9qNnM)
+ Korean: `model.bin` in [mecab-ko-dic](https://bitbucket.org/eunjeon/mecab-ko-dic)

You need entire `mecab-ko-dic` source if you want to compile Korean user dictionary. User dictionary should also be prepared in CSV file. CSV structure is found in [Japanese](http://taku910.github.io/mecab/dic.html) and [Korean](https://bitbucket.org/eunjeon/mecab-ko-dic/src/e39e16059b8748c2663ab09195a08293c7063a28/final/user-dic/README.md?fileviewer=file-view-default).

Compile:

```
$ /usr/local/libexec/mecab/mecab-dict-index -m `model_file` -d `mecab_dic_location` -u `user_dictionary_file_name` -f `CSV file charset` -t `original dictionary charset` `target_csv

# example

$ /usr/local/libexec/mecab/mecab-dict-index -m /usr/local/lib/mecab/dic/mecab-ko-dic/model.bin -d ~/mecab-ko-dic-2.0.3-20170922 -u userdic.dic -f utf8 -t utf8 ~/person.csv
```

### Windows

+ Korean: `mecab-ko-msvc` has `mecab-dict-index.exe`.
+ Japanese: `MeCab` binary version has `mecab-dict-index.exe`.

You can use it in the same way the Linux binary compiles the dictionary.

## TODOs

+ Provide multilanguage manuals for international support

## Author

Junhewk Kim (junhewk.kim@gmail.com)

## Contributor

Kato Akiru
