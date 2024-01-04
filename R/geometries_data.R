#' @title geometries_data
#'
#' @description
#' This function generates a data frame with information about geometries and centroid coordinates of
#' countries. You can choose whether to keep all the countries or a subset.
#'
#' @param exclude.iso.na if `TRUE` (default), countries that do not have a iso code are excluded from the table
#' @param countries.list List of the iso a2 codes of countries that are to be included. By default it is set to `NULL` and all countries are included

#' @return an object of class `data.frame` and `sf`
#' @export
#' @importFrom rnaturalearth ne_countries
#' @importFrom dplyr "%>%"  select filter mutate arrange
#' @importFrom sf st_centroid st_coordinates
#'
#'
#' @examples
#' geometries_data(countries.list = c("IT", "FR", "US"))
#'

geometries_data <- function(exclude.iso.na = TRUE,
                            countries.list = NULL) {
  world <- ne_countries(scale = 50, continent = NULL, returnclass = "sf")

  map_df0<- world %>%
    select(name, iso_a2_eh, iso_a3_eh, geometry) %>%
    mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a2_eh),
           iso_a3 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a3_eh)) %>%
    select(name, iso_a2, iso_a3, geometry)



  sepNat <- c('AQ', 'FJ', 'FR', 'IN', 'RU', 'SD', 'SN', 'SS')

  point_nations<- map_df0  %>%
    filter(!(#is.na(iso_a2) |
      iso_a2 %in% sepNat))

  world_points0<- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))

  leftout <- map_df0 %>%
    filter(iso_a2 %in% sepNat) %>%
    arrange(iso_a2) %>%
    mutate( X = c(0,   178, 2,  79, 40, 30, -14, 31),
            Y = c(-80, -17, 46, 21, 55, 12,  14, 7)) %>%
    relocate(geometry, .after = Y)


  world_points <- rbind(world_points0, leftout)

  if (exclude.iso.na == TRUE) {
    world_points <- world_points %>%
      filter(!(is.na(iso_a2) | iso_a2 == -99))
  }

  if (!is.null(countries.list)) {
    world_points <- world_points %>%
      filter(iso_a2 %in% countries.list)

    notfoundcodes <- countries.list[!(countries.list %in% world_points$iso_a2)]

    if (length(notfoundcodes) > 0) {
      warning("Some iso2 codes you provided (listed above) do not match in the data base: \n")
      print(notfoundcodes)
    }
  }

  return(world_points)

}
