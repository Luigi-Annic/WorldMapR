#' @title worldplotCat
#'
#' @description Plot a world heat map based on a categorical variable.
#'
#' @inheritParams worldplot
#' @param Categories categories labels to be plotted in the legend.
#' @param na.as.category Treat \code{NA} as a separate category? If `\code{TRUE}, NA will also appear in the legend as one of the categories.
#' @param palette_option Character string indicating the palette to be used. Available options range between "A" and "H". You can also enter a string with a colour for each category
#'
#' @return a map
#' @export
#'
#' @importFrom rnaturalearth ne_countries
#' @importFrom countrycode countrycode
#' @importFrom dplyr "%>%" left_join select select filter mutate relocate
#' @importFrom ggplot2 ggplot geom_sf theme labs scale_fill_viridis_d coord_sf xlab ylab ggtitle
#'                     aes unit element_text element_blank element_rect geom_text ggsave scale_fill_manual
#' @importFrom sf st_centroid st_coordinates st_union st_as_sf st_transform st_crs
#' @importFrom ggfx with_shadow
#'
#' @examples
#' data(testdata1b)
#' worldplotCat(data = testdata1b,
#'              div = 1,
#'              ColName = "VCat",
#'              CountryName = "Cshort",
#'              CountryNameType = "isoa2",
#'              annote = FALSE)
#'
worldplotCat <- function(data,
                         ColName, CountryName, CountryNameType,
                         longitude = c(-180, 180) ,latitude = c(-90, 90), crs = NULL,
                         title = "", legendTitle = as.character(ColName),
                         Categories = levels(factor(map_df$MapFiller)),
                         na.as.category = TRUE,
                         annote = FALSE, div = 1, palette_option = "D",
                         save = FALSE, filename = "worldplot.jpg", path = tempdir(),
                         width = 20, height = 10, units = "cm", scale = 1) {

  world <- ne_countries(scale = 50, continent = NULL, returnclass = "sf")

  map_df0<- world %>%
    select(name, iso_a2_eh, iso_a3_eh, geometry) %>%
    mutate(iso_a2 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a2_eh),
           iso_a3 = ifelse(name %in% c("Indian Ocean Ter." , "Ashmore and Cartier Is."), -99, iso_a3_eh)) %>%
    select(name, iso_a2, iso_a3, geometry)

  #Cyprus adjustment
  cyp <- subset(map_df0, name %in% c("Cyprus", "N. Cyprus"))
  cyp2 <- st_union(cyp[1, "geometry"], cyp[2,"geometry"])
  map_df0[map_df0$iso_a2 == "CY", "geometry"] <- cyp2
  # end of cyprus adjustment

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

  wplot <- ggplot(data= map_df) +
    geom_sf(color= 'black', aes(fill= MapFiller)) +
    theme(legend.key.size = unit(1/div, 'lines'),
          legend.text = element_text(size= 8/div),
          legend.title = element_text(size = 8/div),
          plot.title = element_text(size= 8/div),
          panel.grid = element_blank(),
          panel.background = element_rect(fill = 'grey95'))+
    labs(fill= legendTitle)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW') +
    xlab('')+ ylab('')+
    ggtitle(title)

  if (length(palette_option) == 1) {
    wplot <- wplot +
      scale_fill_viridis_d(option = palette_option, begin= 0.3, na.value = 'grey80', direction= 1,
                         labels= c(Categories, "NA"), na.translate = na.as.category)
  } else {
    wplot <- wplot +
      scale_fill_manual(values = palette_option, na.value="grey90", drop= F,
                        labels = Categories, na.translate = na.as.category)
  }

  if (!is.null(crs)) {
    wplot <- wplot +
      coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW',
               crs = st_crs(crs))
  }

  if (annote == TRUE) {

    world_points <- geometries_data(exclude.iso.na = T,
                                    countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)])

    if (!is.null(crs)) {

      d <- data.frame(iso_a2 = world_points$iso_a2,
                      X = world_points$X,
                      Y =world_points$Y)

      d2 <- st_as_sf(d, coords=c("X","Y"), crs="EPSG:4326" )

      d3 <- st_transform(d2, crs = st_crs(crs))

      d4 <- data.frame(iso_a2 = d3$iso_a2,
                       X = rep(NA, nrow(d3)),
                       Y = rep(NA, nrow(d3)))

      for (i in 1: nrow(d3)) {
        d4[i,c("X","Y")] <- d3$geometry[[i]]
      }

      world_points <- d4

    }

    wplot <- wplot +
      with_shadow(geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= 2/div, color= 'white', fontface= 'bold'),
                  x_offset = 2, y_offset = 2, sigma = 1)
  }

  print(wplot)

  if (save == TRUE) {
    ggplot2::ggsave(filename = filename,
                    path = path,
                    width = width,
                    height = height,
                    units = units,
                    dpi = "retina",
                    scale = scale)
  }

}
