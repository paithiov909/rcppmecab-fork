test_that("Test if posSimple works on Japanese", {
  skip_if_not(isDynAvailable(), "No libmecab available. Skip testing.")
  skip_if_not(Sys.getenv("MECAB_LANG") == "ja", "MECAB_LANG is not ja. Skip testing.")
  ## posSimple()
  expect_equal(
    posSimple(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
    )[1, 2],
    enc2utf8("\u982d")
  )
})

test_that("Test if posSimple fails", {
  skip_if_not(isDynAvailable(), "No libmecab available. Skip testing.")
  skip_if_not(Sys.getenv("MECAB_LANG") == "ja", "MECAB_LANG is not ja. Skip testing.")
  ## posSimple()
  expect_error(posSimple(list()))
  expect_error(posSimple(factor()))
})
