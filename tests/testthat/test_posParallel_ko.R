test_that("Test if posParallel works on Korean", {
  skip_on_ci()
  skip_if_not(Sys.getenv("MECAB_LANG") == "ko", "MECAB_LANG is not ko. Skip testing.")
  ## posParallel(format = "list", join = TRUE)
  expect_equal(
    posParallel(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "list",
      join = TRUE
    )[[1]][1],
    enc2utf8("mecab/SL")
  )
  ## posParallel(format = "list", join = FALSE)
  expect_equal(
    posParallel(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "list",
      join = FALSE
    )[[1]][1],
    purrr::set_names(enc2utf8("mecab"), enc2utf8("SL"))
  )
  ## posParallel(format = "data.frame")
  expect_equal(
    posParallel(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "data.frame"
    )[4, 5],
    enc2utf8("SY")
  )
})

test_that("Test if posParallel fails", {
  skip_on_ci()
  skip_if_not(Sys.getenv("MECAB_LANG") == "ko", "MECAB_LANG is not ko. Skip testing.")
  ## posParallel()
  expect_error(posParallel(list()))
  expect_error(posParallel(factor()))
})
