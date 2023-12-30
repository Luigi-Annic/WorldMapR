#' @title worldplot
#'
#' @description Plot a world map for continuous data
#'
#' @param data Data set containing the list of nations and the variable that we want to plot
#' @param div Controlling image quality (and image size). Default value is 1
#' @param ColName character variable with the name of the variable of interest
#' @param CountryName character variable with the name of the country names column
#' @param CountryNameType character variable with the coding for CountryName. It can be "isoa2" (default), "isoa3", or "name"
#' @param rangeVal limit values that are to be defined for the map
#' @param longitude longitude limits. Default is c(-180, 180) (whole world)
#' @param latitude latitude limits. Default is c(-90, 90) (whole world)
#' @param title title of the plot. Default is no title
#' @param legendTitle title of the legend. Default is the name of the filling variable
#' @param annote do you want to plot country labels (iso2 code) on the map?
#'
#' @return a map
#' @export
#' @importFrom rnaturalearth ne_countries
#' @importFrom countrycode countrycode
#' @importFrom dplyr "%>%" left_join select filter mutate relocate
#' @importFrom ggplot2 ggplot geom_sf theme labs scale_fill_viridis_c coord_sf xlab ylab ggtitle aes unit element_text element_blank element_rect geom_text
#' @importFrom sf st_centroid st_coordinates
#'
#' @examples
#' data(testdata1b)
#' worldplot(data = testdata1b,
#'           div = 1,
#'           ColName = "VNum",
#'           CountryName = "Cshort",
#'           CountryNameType = "isoa2",
#'           rangeVal = c(0,50),
#'           annote = FALSE)
#'
worldplot <- function(data, div = 1, ColName, CountryName, CountryNameType = "isoa2", rangeVal,
                      longitude = c(-180, 180) ,latitude = c(-90, 90),
                      title = "", legendTitle = as.character(ColName),
                      annote = FALSE) {

  world <- ne_countries(scale = "medium", continent = NULL, returnclass = "sf")

  map_df0<- world %>%
    select(name, iso_a2, iso_a3, geometry)

  simdata <- c()

  simdata$MapFiller <- data[, which(colnames(data) == ColName)]

  if (CountryNameType == "isoa2") {
    simdata$iso_a2 <- data[, which(colnames(data) == CountryName)]
  } else if (CountryNameType == "name") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == CountryName)],
                                  origin = "country.name", destination = "iso2c")
  } else if (CountryNameType == "isoa3") {
    simdata$iso_a2 <- countrycode(sourcevar = data[, which(colnames(data) == CountryName)],
                                  origin = "iso3c", destination = "iso2c")
  } else {
    simdata$iso_a2 <- NULL
  }

  simdata <- as.data.frame(simdata)

  map_df <- left_join(map_df0, simdata, by = "iso_a2")

  if (annote == FALSE) {
  wplot <- ggplot(data= map_df) +
    geom_sf(color= 'black', aes(fill= MapFiller)) +
    theme(legend.key.size = unit(1, 'lines'),
          legend.text = element_text(size= 8),
          legend.title = element_text(size= 8),
          plot.title = element_text(size=8),
          panel.grid = element_blank(),
          panel.background = element_rect(fill = 'grey95'))+
    labs(fill= legendTitle)+
    scale_fill_viridis_c(option='viridis', na.value = 'grey80',direction=1,begin=0.3, limits= rangeVal)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW') +
    xlab('') + ylab('')+
    ggtitle(title)

  } else if (annote == TRUE) {
    point_nations<- map_df %>%
      filter(!(is.na(iso_a2) | iso_a2 %in% c('RU', 'AQ', 'FJ',
                                             'IN', 'SD','SS', 'SN')))

    world_points0<- cbind(point_nations, st_coordinates(st_centroid(point_nations$geometry)))

    leftout <- map_df %>%
      filter(iso_a2 %in% c('RU', 'AQ', 'FJ', 'IN', 'SD','SS', 'SN')) %>%
      mutate( X = c(0,   178, 79, 40, 30, 31, -14),
              Y = c(-80, -17, 21, 55, 12, 7,  14)) %>%
      relocate(geometry, .after = Y)


    world_points <- rbind(world_points0, leftout)

    world_points <- world_points %>%
      filter(!(is.na(MapFiller)))

    wplot <- ggplot(data= map_df) +
      geom_sf(color= 'black', aes(fill= MapFiller)) +
      theme(legend.key.size = unit(1, 'lines'),
            legend.text = element_text(size= 8),
            legend.title = element_text(size= 8),
            plot.title = element_text(size=8),
            panel.grid = element_blank(),
            panel.background = element_rect(fill = 'grey95'))+
      labs(fill= legendTitle)+
      scale_fill_viridis_c(option='viridis', na.value = 'grey80',direction=1,begin=0.3, limits= rangeVal)+
      coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW') +
      xlab('') + ylab('')+
      ggtitle(title)+
      geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2),size= 2, color= 'black', fontface= 'bold')
  }

  wplot
  }
