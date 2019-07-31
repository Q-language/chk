
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chk

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.com/poissonconsulting/chk.svg?branch=master)](https://travis-ci.com/poissonconsulting/chk)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/poissonconsulting/chk?branch=master&svg=true)](https://ci.appveyor.com/project/poissonconsulting/chk)
[![Codecov test
coverage](https://codecov.io/gh/poissonconsulting/chk/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/chk?branch=master)
[![License:
CC0](https://img.shields.io/badge/License-CC0-blue.svg)](https://creativecommons.org/publicdomain/zero/1.0/)
<!-- badges: end -->

`chk` is an R package for developers to check user-supplied inputs to
their functions.

It is designed to be simple, fast and customisable.

## Installation

To install the latest release version from
[CRAN](https://cran.r-project.org)

``` r
install.packages("chk")
```

To install the latest development version from
[GitHub](https://github.com/poissonconsulting/chk)

``` r
# install.packages("remotes")
remotes::install_github("poissonconsulting/chk")
```

## Demonstration

### Simple

`chk` provides simple commonly used checks which can be combined
together for more complex checking.

``` r
library(chk)

y <- "a"

chk_flag(y)
#> Error: y must be a flag (TRUE or FALSE)
chk_string(y)
#> [1] TRUE

chkor(chk_flag(y), chk_number(y))
#> Error: y must be a flag (TRUE or FALSE) OR y must be a number (non-missing numeric scalar)
chkor(chk_flag(y), chk_string(y))
#> [1] TRUE
```

As the functions are not expected to be used in pipes they simply return
a flag (non-missing logical scalar).

### Fast

The functions are designed to be fast.

As they are not expected to be exposed to users they don’t check any of
their inputs (other than the first argument of course\!).

To allow conditional checking depending on whether the function is
called internal or externally the developer can use something like

``` r
fun <- function(x, chk = TRUE) {
  if(isTRUE(chk)) {
    chk_flag(x)
  }
  x
}

fun(1) # when called by user
#> Error: x must be a flag (TRUE or FALSE)
fun(1, chk = FALSE) # when called internally
#> [1] 1
```

### Customisable

The functions are designed to be customisable.

If `err = FALSE` the `chk` functions return FALSE on check failure.

``` r
chk_flag(1, err = FALSE)
#> [1] FALSE
```

This allows developers to provide their own error message.

``` r
fun <- function(x) {
  if(!chk_flag(x, err = FALSE)) {
    stop("x really should be a flag (try as.logical())")
  }
}
fun(1)
#> Error in fun(1): x really should be a flag (try as.logical())
```

In addition, `chk` is released under the
[CC0](https://creativecommons.org/publicdomain/zero/1.0/) licence so
developers can copy and paste individual functions into their packages
without any need for creditation which is useful if they don’t want
`chk` as a dependency.

## Inspiration

  - [checkr](https://github.com/poissonconsulting/checkr/)

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/chk/issues).

[Pull requests](https://github.com/poissonconsulting/chk/pulls) are
always welcome.

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/poissonconsulting/chk/blob/master/CODE_OF_CONDUCT.md).
By contributing, you agree to abide by its terms
