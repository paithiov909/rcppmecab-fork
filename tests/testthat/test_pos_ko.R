test_that("Test if pos works on Korean", {
  skip_if(
    is_win_running_on_ci(),
    " These tests are currently skipped under Windows machines running on CI."
  )
  skip_if_not(is_dyn_available(), "No libmecab available. Skip testing.")
  skip_if_not(Sys.getenv("MECAB_LANG") == "ko", "MECAB_LANG is not ko. Skip testing.")
  ## pos(format = "list", join = TRUE)
  expect_equal(
    pos(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "list",
      join = TRUE
    )[[1]][1],
    enc2utf8("mecab/SL")
  )
  ## pos(format = "list", join = FALSE)
  expect_equal(
    pos(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "list",
      join = FALSE
    )[[1]][1],
    purrr::set_names(enc2utf8("mecab"), enc2utf8("SL"))
  )
  ## pos(format = "data.frame")
  expect_equal(
    pos(
      enc2utf8("mecab-ko-dic-msvc\ub294 mecab-ko-msvc\uc5d0\uc11c \uc0ac\uc6a9\ud560 \uc218 \uc788\ub294 mecab-ko-dic\uc744 \ube4c\ub4dc\ud558\ub294 \ud504\ub85c\uc81d\ud2b8\uc785\ub2c8\ub2e4"),
      format = "data.frame"
    )[4, 4],
    enc2utf8("SY")
  )
})

test_that("Test if pos fails", {
  skip_if(
    is_win_running_on_ci(),
    " These tests are currently skipped under Windows machines running on CI."
  )
  skip_if_not(is_dyn_available(), "No libmecab available. Skip testing.")
  skip_if_not(Sys.getenv("MECAB_LANG") == "ko", "MECAB_LANG is not ko. Skip testing.")
  ## pos()
  expect_error(pos(list()))
  expect_error(pos(factor()))
})
