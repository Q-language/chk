comment_chks <- function(lines, ...) {
  chk_vector(lines)
  chk_character(lines)
  chk_not_any_na(lines)

  rx <- "(^\\s*)((?:chk\\s*::\\s*)?che{0,1}c{0,1}k_[[:alpha:]](?:\\w|\\.)*\\s*\\()(.*#\\s*[+]chk(?:\\s|$))$"

  sub(rx, "\\1# !chk \\2\\3", lines, perl = TRUE)
}

uncomment_chks <- function(lines, ...) {
  chk_vector(lines)
  chk_character(lines)
  chk_not_any_na(lines)

  rx <- "^(\\s*)#\\s*!\\s*chk\\s"

  sub(rx, "\\1", lines)
}

#' Elide Chk Calls
#'
#' @export
rpp_elide_chk_calls <- function() {
  stopifnot(rlang::is_installed("rpp"))

  rpp::inline_plugin(dev = uncomment_chks, prod = comment_chks)
}
