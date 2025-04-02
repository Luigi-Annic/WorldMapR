#' @title geometries_data
#'
#' @description
#' This function is deprecated and not exported. It has been substituted with worldMapR::countrycoord_data.
#' This function generates a data frame with information about geometries and centroid coordinates of
#' countries. You can choose whether to keep all the countries or only a subset.
#'
#' @param exclude.iso.na if \code{TRUE} (default), countries that do not have a ISO 3166 code are excluded from the table.
#' @param countries.list List of the ISO 3166-1 alpha-2 codes of countries that are to be included. By default it is set to \code{NULL} and all countries are included.
#' 
#' @export
#' 
#' @return an object of class \code{data.frame} and \code{sf}.
#'


geometries_data <- function(exclude.iso.na = TRUE,
                            countries.list = NULL) {
  
  
  warning("geometries_data is deprecated; switch to the function WorldMapR::countrycoord_data,
          which provides the same basic functions plus additional features")

#  sepNat <- c('AQ', 'DK' ,'FJ', 'FR', 'GB', 'GR', 'HR' , 'IL' , 'IN', 'NO',
#              'RU', 'SD', 'SN', 'SS')

#  point_nations<- map_df0  %>%
#    filter(!(#is.na(iso_a2) |
#      iso_a2 %in% sepNat))

#  world_points0<- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))

#  leftout <- map_df0 %>%
#    filter(iso_a2 %in% sepNat) %>%
#    arrange(iso_a2) %>%
#    mutate( X = c(0,   9,  178, 2, -1, 21.5,
#                  17, 35, 79, 10,
#                  40, 30, -14, 31),

#            Y = c(-80, 56, -17, 46, 52.5, 39.5,
#                  45.5, 31 ,21, 61,
#                  55, 12,  14, 7)) %>%
#    relocate(geometry, .after = Y)


#  world_points <- rbind(world_points0, leftout)

#  if (exclude.iso.na == TRUE) {
#    world_points <- world_points %>%
#      filter(!(is.na(iso_a2) | iso_a2 == -99))
#  }

#  if (!is.null(countries.list)) {
#    world_points <- world_points %>%
#      filter(iso_a2 %in% countries.list)

#    notfoundcodes <- countries.list[!(countries.list %in% world_points$iso_a2)]

#    if (length(notfoundcodes) > 0) {
#      warning("One or more iso2 codes you provided (listed above) do not match in the data base")
#      message(notfoundcodes)
#    }
#  }

#  return(world_points)
  
}
