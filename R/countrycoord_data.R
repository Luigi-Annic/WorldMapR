#' @title countrycoord_data
#'
#' @description
#' This function generates a data frame with information about the coordinates of the central point for each
#' country of interest. You can choose whether to keep all the countries or only a subset.
#'
#' @param countries.list List of the ISO 3166-1 alpha-2 codes of countries that are to be included. By default it is set to \code{NULL} and all countries are included.
#' @param crs Coordinate reference system (EPSG). By default the value is 4326, which corresponds to EPSG::4326 (WGS84)
#' @param UK_as_GB Do you want to translate the GB isoa2 code to UK? If FALSE, GB is returned in the output data.frame. 
#'                 If TRUE (default), UK is returned.
#'              
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
  
  sepNat <- c("AQ", "DK", "FJ", "FR", "GB",
              "GR", "HR", "IL", "IN", "NL","NO",
              "RU", "SD", "SE", "SN", "SS")
  point_nations <- map_df0 %>% filter(!(iso_a2 %in% sepNat))
  world_points0 <- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))
  leftout <- map_df0 %>% filter(iso_a2 %in% sepNat) %>% arrange(iso_a2) %>% 
    mutate(X = c(0    ,9.2  ,178  ,2    , -1  ,
                 21.5 ,16.8 ,35   ,79   ,5.7  , 10  ,
                 40   ,30   ,16   ,-14  ,31
                 ),
           Y = c(-80  ,56   ,-17  , 46  ,52.5 ,
                 39.5 ,45.7 ,31   , 21  ,52.5 ,61   ,
                 55   ,12   ,60   ,14   , 7
                 )) %>% 
    relocate(geometry, .after = Y)
  
  world_points <- rbind(world_points0, leftout)
  if (exclude.iso.na == TRUE) {
    world_points <- world_points %>% filter(!(is.na(iso_a2) | 
                                                iso_a2 == -99))
  }
  
  if (UK_as_GB == TRUE) {
    countries.list <- replace(countries.list, countries.list =="GB", "UK")
    world_points$iso_a2[world_points$name == "United Kingdom"] <- "UK"
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
