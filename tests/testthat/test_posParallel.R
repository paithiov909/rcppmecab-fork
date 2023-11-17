test_that("posParallel works on Japanese", {
  skip_on_cran()

  skip_if(Sys.getenv("MECAB_LANG") != "ja")
  ## posParallel(format = "list", join = TRUE)
  expect_equal(
    posParallel(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "list",
      join = TRUE
    )[[1]][1],
    enc2utf8("\u982d/\u540d\u8a5e")
  )
  ## posParallel(format = "list", join = FALSE)
  expect_equal(
    posParallel(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "list",
      join = FALSE
    )[[1]][1],
    stats::setNames(enc2utf8("\u982d"), enc2utf8("\u540d\u8a5e"))
  )
  ## posParallel(format = "data.frame")
  expect_snapshot_value(
    posParallel(
      enc2utf8("\u982d\u304c\u8d64\u3044\u9b5a\u3092\u98df\u3079\u305f\u732b"),
      format = "data.frame"
    ),
    style = "json2",
    cran = FALSE
  )
})
