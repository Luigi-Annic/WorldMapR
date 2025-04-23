#' @title empty_editable_map
#'
#' @description Plot a world map which can be edited in powerpoint.
#'
#' @param lon Longitude limits.
#' @param lat Latitude limits.
#' @param crs Coordinate reference system (EPSG). By default the value is 4326, which corresponds to EPSG::4326 (WGS84)
#' @param sf_use_s2 sf_use_s2 option, deafult is FALSE

#' @return a map
#' @export
#'
#' @examples
#' \dontrun{empty_editable_map(lon = c(2600000, 9300000), lat = c(5450000, 1000000), crs = 3035)
#' export::graph2ppt(file ="editable_map.pptx", width = 7, height = 4)}
#' \dontrun{empty_editable_map(lon = c(-15, 40), lat = c(20, 65), crs = 4326)}
#'

empty_editable_map <- function(lon, lat, crs = 4326, sf_use_s2 = FALSE) {
  
  sf_use_s2(sf_use_s2)
  map_df0c <- st_transform(WorldMapR::map_df0, crs) 
  Poly_Coord_df = data.frame(lon, lat)
  
  # poly is the polygon contained within the ocordinates
  poly <- st_as_sfc(st_bbox(st_as_sf(Poly_Coord_df, coords = c("lon", "lat"), crs = crs)))
  
  # For each country:
  # - if the country is in poly, then truncate it to it only
  # - if the country is completely outside, delete that geometry (it won't be used)
  # This passage is necessary as trying to crop a polygon which is completely outside of the cropping space yields error
  
  for (j in 1:nrow(map_df0c)) {
    if (as.vector(suppressMessages(st_intersects(poly, map_df0c$geometry[j], sparse = FALSE)))){
      map_df0c$geometry[j] <- suppressMessages(
        st_crop(map_df0c$geometry[j], c(xmin=Poly_Coord_df$lon[1], xmax=Poly_Coord_df$lon[2], 
                                        ymin=Poly_Coord_df$lat[1], ymax=Poly_Coord_df$lat[2])))
    } else {
      map_df0c$geometry[j]<- NULL
    }
  }
  
  bbox_list <- lapply(st_geometry(map_df0c$geometry), st_bbox)
  maxmin <- as.data.frame(matrix(unlist(bbox_list),nrow=nrow(map_df0c), byrow = TRUE))
  names(maxmin) <- names(bbox_list[[1]])
  
  plot <- ggplot(data = map_df0c) +
    geom_sf() +
    theme(legend.position = "none",
          panel.grid = element_blank(), 
          panel.background = element_rect(fill = "grey95")) + 
    labs(fill = "") +
    coord_sf(xlim = c(min(maxmin$xmin, na.rm = TRUE), max(maxmin$xmax, na.rm = TRUE)), 
             ylim = c(min(maxmin$ymin, na.rm = TRUE), max(maxmin$ymax, na.rm = TRUE)),
             expand = FALSE, label_axes = "SW", crs = st_crs(crs)) + 
    xlab("") + ylab("")
  
  return(plot)
}