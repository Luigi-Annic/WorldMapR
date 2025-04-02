#' @title countrycoord_data
#'
#' @description
#' This function generates a data frame with information about the coordinates of the central point for each
#' country of interest. You can choose whether to keep all the countries or only a subset.
#'
#' @param countries.list List of the ISO 3166-1 alpha-2 codes of countries that are to be included. By default it is set to \code{NULL} and all countries are included.
#' @param crs Coordinate reference system (EPSG). By default the value is 4326, which corresponds to EPSG::4326 (WGS84)
#' @param UK_as_GB Which do you prefer between UK and GB as the code for the United Kingdom? If FALSE, GB is returned in the output data.frame. 
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
  
  sepNat <- as.data.frame(
    rbind(c("AQ", 0,   -80),
          c("DK", 9.2, 56 ),
          c("FJ", 178, -17),
          c("FR", 2, 47),
          c("GB", -1  ,52.5),
          c("GR", 21.5 ,39.5 ),
          c("HR", 16.7 ,45.7),
          c("IL", 35   ,31 ),
          c("IN", 79   ,21),
          c("NL", 5.7  ,52.5),
          c("NO", 10  ,61 ),
          c("PT", -8.2, 39.5),
          c("RU", 40 , 55),
          c("SD", 30   ,12 ),
          c("SE", 15   ,60 ),
          c("SN", -14  ,14),
          c("SS", 31, 7)
    ))
  
  colnames(sepNat) <- c("iso_a2", "X", "Y")
  
  #point_nations <- map_df0 %>% filter(!(iso_a2 %in% sepNat$iso_a2)) 
  #world_points0 <- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry))) %>%
  #  as.data.frame() %>%
  #  select(iso_a2, X, Y)
  
  point_nations <- subset(WorldMapR::map_df0, !(iso_a2 %in% sepNat$iso_a2))
  world_points0 <- subset(as.data.frame(cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))),
                          select = c("iso_a2", "X", "Y"))

  world_points <- rbind(world_points0, sepNat)
  
  if (exclude.iso.na == TRUE) {
    
    #world_points <- world_points %>% filter(!(is.na(iso_a2) | iso_a2 == -99))
    world_points <- subset(world_points, !(is.na(iso_a2) | iso_a2 == -99))
  }
  
  if (UK_as_GB == TRUE) {
    countries.list <- replace(countries.list, countries.list =="GB", "UK")
    world_points$iso_a2[world_points$iso_a2 == "GB"] <- "UK"
  }
  
  
  if (length(countries.list >0)) {
    #world_points <- world_points %>% filter(iso_a2 %in% countries.list)
    world_points <- subset(world_points, iso_a2 %in% countries.list)
    
    notfoundcodes <- countries.list[!(countries.list %in% world_points$iso_a2)]
    
    if (length(notfoundcodes) > 0) {
      warning("One or more iso2 codes you provided (listed above) do not match in the data base")
      message(notfoundcodes)
    }
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
  
  world_points$X <- as.numeric(world_points$X)
  world_points$Y <- as.numeric(world_points$Y)
  
  return(world_points)
}
