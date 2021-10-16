test_that("comment_chks works no length", {
  expect_identical(comment_chks(character(0)), character(0))
})

test_that("comment_chks requires opt in", {
  expect_identical(comment_chks("chk_flag(TRUE)"),
                   "chk_flag(TRUE)")
})

test_that("comment_chks works single row", {
  expect_identical(comment_chks("chk_flag(TRUE) # +chk"),
                   "# !chk chk_flag(TRUE) # +chk")
})

test_that("comment_chks works check", {
  expect_identical(comment_chks("check_flag(TRUE) # +chk"),
                   "# !chk check_flag(TRUE) # +chk")
})

test_that("comment_chks works single row chk::", {
  expect_identical(comment_chks("chk::chk_flag(TRUE) # +chk"),
                   "# !chk chk::chk_flag(TRUE) # +chk")
})

test_that("comment_chks works single row with spaces ", {
  expect_identical(comment_chks(" chk :: chk_flag ( TRUE)   #  +chk "),
                   " # !chk chk :: chk_flag ( TRUE)   #  +chk ")
})

test_that("comment_chks works single row with two chk statements ", {
  expect_identical(comment_chks("chk::chk_flag(TRUE); chk::chk_string(TRUE) # +chk"),
                   "# !chk chk::chk_flag(TRUE); chk::chk_string(TRUE) # +chk")
})

test_that("comment_chks works multiple rows ", {
  expect_identical(comment_chks(c(
    "chk_flag(TRUE) # +chk",
    "chk_string(TRUE) # +chk")),
    c("# !chk chk_flag(TRUE) # +chk", "# !chk chk_string(TRUE) # +chk"))
})

test_that("comment_chks works multiple rows only 1 chk ", {
  expect_identical(comment_chks(c(
    "chk_flag(TRUE) # +chk",
    "is.string(TRUE) # +chk")),
    c("# !chk chk_flag(TRUE) # +chk", "is.string(TRUE) # +chk"))
})

test_that("uncomment_chks works no length", {
  expect_identical(uncomment_chks(character(0)), character(0))
})

test_that("uncomment_chks works single row", {
  expect_identical(uncomment_chks(comment_chks("# !chk chk_flag(TRUE)")),
                   "chk_flag(TRUE)")
})

test_that("uncomment_chks works check::", {
  expect_identical(uncomment_chks(comment_chks("# !chk chk::check_flag(TRUE)")),
                   "chk::check_flag(TRUE)")
})

test_that("uncomment_chks works anything", {
  expect_identical(uncomment_chks(comment_chks("# !chk anything(TRUE)")),
                   "anything(TRUE)")
})

test_that("uncomment_chks works single row with spaces ", {
  expect_identical(uncomment_chks(comment_chks(" # !chk   chk :: chk_flag ( TRUE)")),
                   "   chk :: chk_flag ( TRUE)")
})

test_that("uncomment_chks works single row with two chk statements ", {
  expect_identical(uncomment_chks(comment_chks("# !chk chk::chk_flag(TRUE); chk::chk_string(TRUE)")),
                   "chk::chk_flag(TRUE); chk::chk_string(TRUE)")
})

test_that("uncomment_chks works multiple rows ", {
  expect_identical(uncomment_chks(comment_chks(c(
    "# !chk chk_flag(TRUE)",
    "# !chk chk_string(TRUE)"))),
    c(
      "chk_flag(TRUE)",
      "chk_string(TRUE)"))
})

test_that("uncomment_chks works multiple rows only 1 chk ", {
  expect_identical(uncomment_chks(comment_chks(c(
    "# !chk chk_flag(TRUE)",
    "is.string(TRUE)"))),
    c("chk_flag(TRUE)", "is.string(TRUE)"))
})

test_that("uncomment_chks works gaps ", {
  expect_identical(uncomment_chks(" #  !chk chk_flag(TRUE)"),
                   " chk_flag(TRUE)")
})

test_that("uncomment_chks preserves indentation ", {
  expect_identical(uncomment_chks(" #  !chk  chk_flag(TRUE)"),
                   "  chk_flag(TRUE)")
})

test_that("opt-in elision", {
  expect_snapshot({
    writeLines(comment_chks(c(
      "chk_stuff()",
      "chk_stuff() #+chk",
      "chk_stuff()         #+chk",
      "chk_stuff()         #+chk anything",
      "chk_stuff() # +chk",
      "chk_stuff()         # +chk",
      "chk_stuff()         # +chk anything",
      "chk_stuff() #          +chk",
      "chk_stuff()        #   +chk",
      "chk_stuff()         #  +chk anything",
      NULL
    )))
  })
})
