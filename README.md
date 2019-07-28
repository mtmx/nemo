
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nemo

`nemo` finds the [largest empty
circle](https://www.cs.swarthmore.edu/~adanner/cs97/s08/papers/schuster.pdf)
in the plane whose interior does not overlap with any given obstacles.
`nemo` includes ony two functions :

  - `nemo_hull` computes a concave hull from a set of points and is
    basically imported from package
    [concaveman](https://github.com/mapbox/concaveman) brought in R by
    [joelgombin](https://github.com/joelgombin/concaveman)
  - `nemo_circle` computes the larget circle inside a hull and which
    doesn’t include any point : its center will be the point nemo

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

A basic example to find the largest empty circle inside a set of points
and its center aka the point nemo :

``` r
data(points)
hull_pts <-
nemo_hull(points = points %>% st_transform(2154),
            concavity =2,
            length_threshold = 10)

nemo_pts <-
nemo_circle(points = points %>% st_transform(2154),
            hull = hull_pts,
            strict_inclusion = T,
            nmax_circles = 1)

# mapping output
library(mapview)

mapview(list(hull_pts,
             nemo_pts %>% filter(id_vor == 1),
             nemo_pts %>% filter(id_vor == 1) %>% st_centroid()),
        layer.name = c("Points",
                       "Nemo point", 
                       "Empty circle"),
        fill = NA)
```
