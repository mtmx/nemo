library(nemo)
library(concaveman)
library(sf)
library(dplyr)
library(magrittr)
data(points)
context("test-nemo_circle")

test_that("points format", {
  expect_s3_class(nemo_hull(points), "sf")
})

test_that("hull format", {
  hull_pts <- nemo_hull(points = points %>% st_transform(2154))
  expect_s3_class(nemo_circle(points %>% st_transform(2154),hull=hull_pts), "sf")
})
