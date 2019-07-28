#' @name nemo_circle
#'
#' @title Computes the largest empty circle which doesn't contain any points, inside a defined hull.
#'
#' @description
#'
#' @param points a set of points (an `sf` object).
#' @param hull external limits of the set of points (a polygon type `sf` object). Can be imported or computed with `nemo_hull` function, with the coordinate reference system as points object.
#' @param strict_inclusion TRUE if empty circle has to be entirely within the hull, FALSE otherwise.
#' @param nmax_circles number of empty circles in output.
#'
#' @return an `sf` object.
#'
#' @import dplyr concaveman sf nngeo magrittr
#'
#' @examples
#'\donttest{
#' data(points)
#' nemo_pts <-
#' nemo_circle(points = points %>% st_transform(2154),
#'            hull = hull_pts,
#'            strict_inclusion = T,
#'            nmax_circles = 1)
#'}
#'
#' @export

nemo_circle <- function(points,
                          hull,
                          strict_inclusion,
                          nmax_circles){
  # default parameters
  if (missing(nmax_circles)) {nmax_circles <- 1}
  if (missing(strict_inclusion)) {strict_inclusion <- TRUE}

  # check if points and hull have the same projection system
  if (st_crs(points) != st_crs(hull)) {
    stop("Points and hull must have the same crs.")
  }

  # warning lot of points to compute
  if (nrow(points) > 10000  ) {
    warning("Point nemo could be hard to find, i.e. long to compute.")
  }

  # clean hull
  hull <- hull %>% summarise() %>% st_geometry()

  # check points format
  class(points) <- c("sf","data.frame")

  # strict inclusion in hull
  if( strict_inclusion == TRUE ) {
    # add points of hull
    points <- st_geometry(points) %>%
      st_sf() %>%
      rbind(hull %>%
              st_cast(., "POINT") %>%
              st_sf())
  }
  else {
    points
  }




  # computation of voronoi

  vor <- st_voronoi(x = st_union(points))
  vor <- st_intersection(st_cast(vor), hull)
  vor_pts <- st_coordinates(st_cast(vor, "POINT"))

  vor_pts_hull <- vor_pts %>%
    as.data.frame() %>%
    select(x=X,y=Y) %>%
    st_as_sf(., coords = c("x", "y"), crs = st_crs(points)) %>%
    mutate(id_vor = row_number())

  # nearest point of each voronoi vertex
  reach.nearest.pt <- st_nn(vor_pts_hull, points, returnDist = TRUE)

  reach.nearest.pt.df <- reach.nearest.pt$nn %>%
    unlist(.) %>%
    as.data.frame() %>%
    set_colnames("id") %>%
    mutate(id_vor = row_number()) %>%
    cbind.data.frame(reach.nearest.pt$dist %>%
                       as.vector() %>%
                       as.data.frame() %>%
                       set_colnames("dist_max"))


  vor_pts_hull.dist <- vor_pts_hull %>%
    select(id_vor, geometry) %>%
    left_join(reach.nearest.pt.df %>%
                select(id_vor, dist_max),
              by = "id_vor")

  vor_pts_hull.dist <- vor_pts_hull.dist %>%
    distinct(geometry, .keep_all = T)

  # circles
  vor_pts_hull.dist <- vor_pts_hull.dist %>% st_buffer(.,dist = vor_pts_hull.dist$dist_max)

  # strict inclusion in hull
  if( strict_inclusion == TRUE ) {

    vor_pts_hull.dist.out <- st_difference(vor_pts_hull.dist, hull %>% st_sf()) %>% pull(id_vor) %>% as.vector()
    vor_pts_hull.dist <- vor_pts_hull.dist %>%
      filter(!id_vor %in% vor_pts_hull.dist.out)
  }
  else {
    vor_pts_hull.dist
  }

  final <- vor_pts_hull.dist %>%
    arrange(desc(dist_max)) %>%
    mutate(id_vor = row_number()) %>%
    top_n(nmax_circles,dist_max)
}
