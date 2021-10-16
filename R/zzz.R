.onLoad <- function(libname, pkgname) {
  # Called for the side effect of loading but not attaching the typed package:
  requireNamespace("typed", quietly = TRUE)
}
