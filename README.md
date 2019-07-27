
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nemo

`nemo` finds the [largest empty
circle](https://www.cs.swarthmore.edu/~adanner/cs97/s08/papers/schuster.pdf)
in the plane whose interior does not overlap with any given obstacles.
`nemo` includes ony two functions :

  - `nemo_hull` computes a concave hull from a set of points and is
    basically imported from package
    [concaveman](https://github.com/mapbox/concaveman) brought in R by
    \[@joelgombin\](<https://github.com/joelgombin/concaveman>) )
  - `nemo_circle` computes the larget circle inside a hull and which
    doesn’t include any point

## Installation

You can install the development version from
[GitHub](https://github.com/mtmx/nemo) with:

``` r
## install {remotes} if not already
if (!requireNamespace("remotes")) {
  install.packages("remotes")
}
## install nemo for github
remotes::install_github("mtmx/nemo")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```
