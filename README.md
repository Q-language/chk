
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chk

<!-- badges: start -->

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.com/poissonconsulting/chk.svg?branch=master)](https://travis-ci.com/poissonconsulting/chk)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/poissonconsulting/chk?branch=master&svg=true)](https://ci.appveyor.com/project/poissonconsulting/chk)
[![Codecov test
coverage](https://codecov.io/gh/poissonconsulting/chk/branch/master/graph/badge.svg)](https://codecov.io/gh/poissonconsulting/chk?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Tinyverse
status](https://tinyverse.netlify.com/badge/chk)](https://CRAN.R-project.org/package=chk)
[![CRAN
status](https://www.r-pkg.org/badges/version/chk)](https://cran.r-project.org/package=chk)
![CRAN downloads](http://cranlogs.r-pkg.org/badges/chk)
<!-- badges: end -->

`chk` is an R package for developers to check user-supplied function
arguments.

It is designed to be simple, customizable and fast.

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

To install the latest developmental release from the Poisson drat
[repository](https://github.com/poissonconsulting/drat)

``` r
# install.packages("drat")
drat::addRepo("poissonconsulting")
install.packages("chk")
```

## Demonstration

### Simple

`chk` provides simple commonly used checks as (`chk_` functions) which
can be combined together for more complex checking.

``` r
library(chk)

y <- "a"

chk_flag(y)
#> Error: `y` must be a flag (TRUE or FALSE).
chk_string(y)

data <- data.frame(x = 1:2)
chk_is(data, "data.frame")
chk_range(nrow(data), c(3,8))
#> Error: `nrow(data)` must be between 3 and 8, not 2.
chk_in(nrow(data), c(3,8))
#> Error: `nrow(data)` must match 3 or 8, not 2.

chk_identical(data$x, 2:1)
#> Error: `data$x` must be identical to: 2:1.

z <- "b"
chkor(chk_flag(z), chk_number(z))
#> Error: At least one of the following conditions must be met:
#> * `z` must be a flag (TRUE or FALSE).
#> * `z` must be a number (non-missing numeric scalar).
```

Error messages follow the [tidyverse style
guide](https://style.tidyverse.org/error-messages.html).

### Customizable

#### Custom Error Messages

The `vld_` variant of each `chk_` function returns FALSE (instead of
throwing an error) on check failure.

``` r
vld_flag(TRUE)
#> [1] TRUE
vld_flag(1)
#> [1] FALSE
```

This allows developers to provide their own error messages.

``` r
if(!vld_flag(1)) stop("x MUST be a flag (try as.logical())")
#> Error in eval(expr, envir, enclos): x MUST be a flag (try as.logical())
```

### Fast

The functions are designed to be fast.

#### Check First

As exemplified by `chk_flag`, the `chk_` functions immediately evaluate
their object.

``` r
chk_flag
#> function(x, x_name = NULL){
#>   if(vld_flag(x)) return(invisible())
#>   if(is.null(x_name))  x_name <- paste0("`", deparse(substitute(x)), "`")
#>   stop(x_name, " must be a flag (TRUE or FALSE).", call. = FALSE)
#> }
#> <bytecode: 0x7fd93e469568>
#> <environment: namespace:chk>
```

#### Minimal Checking

As they are not expected to be directly exposed to users the `chk_` and
`vld_` functions don’t check any of their arguments (other than the
object of interest of course\!).

#### Turn Off Checking

If a function is being called internally the checks can be turned off as
follows

``` r
fun <- function(x, ...) {
  if(is_chk_on()) {
    chk_flag(x)
    chk_unused(...)
  }
  x
}

wrapper_on_fun <- function(x) {
  if(is_chk_on()) {
    chk_off()
    on.exit(chk_on())
  }
  fun(x)
}

fun(FALSE) # calls fun with checking as being called by user
#> [1] FALSE
wrapper_on_fun(FALSE) # calls fun without checking as being used internally
#> [1] FALSE
```

It is only worth doing this if the checks are substantially slower than
the time required to test and turn checking on and off (see
[Benchmarking
chk](https://poissonconsulting.github.io/chk/articles/benchmarking-chk.html))

## Inspiration

  - [datacheckr](https://github.com/poissonconsulting/datacheckr/)
  - [checkr](https://github.com/poissonconsulting/checkr/)
  - [err](https://github.com/poissonconsulting/err/)
  - [testthat](https://github.com/r-lib/testthat/)

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/chk/issues).

[Pull requests](https://github.com/poissonconsulting/chk/pulls) are
always welcome.

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/poissonconsulting/chk/blob/master/CODE_OF_CONDUCT.md).
By contributing, you agree to abide by its terms.
