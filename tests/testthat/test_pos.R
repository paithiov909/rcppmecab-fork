skip_on_cran()

test_that("pos works on Japanese", {
  skip_if(Sys.getenv("MECAB_LANG") != "ja")
  ## pos(format = "list", join = TRUE)
  expect_equal(
    pos(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "list",
      join = TRUE
    )[[1]][1],
    enc2utf8("\u982d/\u540d\u8a5e")
  )
  ## pos(format = "list", join = FALSE)
  expect_equal(
    pos(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "list",
      join = FALSE
    )[[1]][1],
    purrr::set_names(enc2utf8("\u982d"), enc2utf8("\u540d\u8a5e"))
  )
  ## pos(format = "data.frame")
  expect_equal(
    pos(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "data.frame"
    )[4, 4],
    enc2utf8("\u9b5a")
  )
})

test_that("pos fails", {
  expect_error(pos(list()))
  expect_error(pos(factor()))
})
