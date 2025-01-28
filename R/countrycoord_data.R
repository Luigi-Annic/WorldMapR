#' @title countrycoord_data
#'
#' @description
#' This function generates a data frame with information about the coordinates of the central point for each
#' country of interest. You can choose whether to keep all the countries or only a subset.
#'
#' @param countries.list List of the ISO 3166-1 alpha-2 codes of countries that are to be included. By default it is set to \code{NULL} and all countries are included.
#' @param crs Coordinate reference system (EPSG). By default the value is 4326, which corresponds to EPSG::4326 (WGS84)
#' @param UK_as_GB Do you want to translate the GB isoa2 code to UK? If FALSE, GB is returned in the output data.frame. 
#'                If TRUE, UK is returned.
#'                Note that you will need to provide GB as the input for United Kingdom, even if you want the UK label to be
#'                returned in output.  
#' @param exclude.iso.na if \code{TRUE} (default), countries that do not have a ISO 3166 code are excluded from the table.
#'
#' @return an object of class \code{data.frame}
#' @export
#'
#' @examples
#' countrycoord_data(countries.list = c("IT", "FR", "SE"), crs = 3035)
#' countrycoord_data(countries.list = c("IT", "FR", "SE"), crs = 3035)
#' countrycoord_data(countries.list = c("IT", "FR", "SE", "GB"), crs = 3035, UK_as_GB = TRUE)
#' countrycoord_data(countries.list = c("IT", "FR", "SE", "GB"), crs = 3035, UK_as_GB = FALSE)
#' 

countrycoord_data <- function (countries.list = NULL, crs = 4326, UK_as_GB = TRUE, exclude.iso.na = TRUE) {
  
  world <- ne_countries(scale = 50, continent = NULL, returnclass = "sf")
  map_df0 <- world %>% select(name, iso_a2_eh, iso_a3_eh, geometry) %>% 
    mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter.", 
                                       "Ashmore and Cartier Is."), -99, iso_a2_eh),
           iso_a3 = ifelse(name %in%  c("Indian Ocean Ter.", "Ashmore and Cartier Is."), -99, iso_a3_eh)) %>% 
    select(name, iso_a2, iso_a3, geometry)
  
  sepNat <- c("AQ", "DK", "FJ", "FR", "GB", "GR", "HR", "IL", 
              "IN", "NO", "RU", "SD", "SN", "SS")
  point_nations <- map_df0 %>% filter(!(iso_a2 %in% sepNat))
  world_points0 <- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))
  leftout <- map_df0 %>% filter(iso_a2 %in% sepNat) %>% arrange(iso_a2) %>% 
    mutate(X = c(0, 9, 178, 2, -1, 21.5, 17, 35, 79, 10, 
                 40, 30, -14, 31),
           Y = c(-80, 56, -17, 46, 52.5, 39.5, 
                 45.5, 31, 21, 61, 55, 12, 14, 7)) %>% relocate(geometry, .after = Y)
  
  world_points <- rbind(world_points0, leftout)
  if (exclude.iso.na == TRUE) {
    world_points <- world_points %>% filter(!(is.na(iso_a2) | 
                                                iso_a2 == -99))
  }
  if (!is.null(countries.list)) {
    world_points <- world_points %>% filter(iso_a2 %in% countries.list)
    notfoundcodes <- countries.list[!(countries.list %in% 
                                        world_points$iso_a2)]
    if (length(notfoundcodes) > 0) {
      warning("One or more iso2 codes you provided (listed above) do not match in the data base")
      message(notfoundcodes)
    }
  }
  
  world_points <- data.frame(iso_a2 = world_points$iso_a2,
                             X = world_points$X, 
                             Y =world_points$Y)
  
  if (UK_as_GB == TRUE) { # United Kingdom code adjustment
    world_points[world_points$iso_a2 == "GB", "iso_a2"] <- "UK"   
  }
  
  if (crs != 4326) {
    
    d2 <- st_as_sf(world_points, coords=c("X","Y"), crs="EPSG:4326" )
    d3 <- st_transform(d2, crs = st_crs(crs))
    
    d4 <- data.frame(iso_a2 = d3$iso_a2, 
                     X = rep(NA, nrow(d3)),
                     Y = rep(NA, nrow(d3)))
    
    for (i in 1: nrow(d3)) {
      d4[i,c("X","Y")] <- d3$geometry[[i]]
    }
    
    world_points <- d4
  }
  
  return(world_points)
}
