#' @name nemo_hull
#'
#' @title Computes the concave polygon for a set of points
#'
#' @description Uses the `concaveman` function from [concaveman](https://github.com/mapbox/concaveman) and [concaveman in R](https://github.com/joelgombin/concaveman))
#'
#' @param points points for which the concave hull must be computed (an `sf` object).
#' @param group optional : a field which splits the hull (a field of the `sf` object).
#' @param concavity a relative measure of concavity. 1 results in a relatively detailed shape, Infinity results in a convex hull. You can use values lower than 1, but they can produce pretty crazy shapes.
#' @param length_threshold when a segment length is under this threshold, it stops being considered for further detalization. Higher values result in simpler shapes.
#'
#' @return an `sf` object.
#'
#' @import dplyr concaveman
#'
#' @examples
#'
#' data(points)
#' hull_pts <-
#' nemo_hull(points = points %>% st_transform(2154),
#'            #group_hull = k,
#'            concavity =2,
#'            length_threshold = 10)
#'
#'
#'
#' @export

nemo_hull <- function(points, group_hull, concavity, length_threshold){

  # default parameters
  if (missing(group_hull)) {group_hull = NA}
  if (missing(concavity)) {concavity = 2}
  if (missing(length_threshold)) {length_threshold = 0}

  if( is.na(group_hull)  ) {

    polygons <- concaveman(points,
                           concavity = concavity,
                           length_threshold = length_threshold)

  }

  # hull by group of points

  else {
    polygons <- map(points %>% pull(!!sym(group_hull)) %>% unique(),
                    ~ concaveman(points %>% filter(!!sym(group_hull) %in% .x),
                                 concavity = concavity,
                                 length_threshold = length_threshold)
    ) %>%
      map2(points %>% pull(!!sym(group_hull)) %>% unique(),
           ~ mutate(.x, group_hull = .y)) %>%
      reduce(rbind)

  }
}
