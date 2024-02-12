#' @title worldplotCat
#'
#' @description Plot a world heat map based on a categorical variable.
#'
#' @inheritParams worldplot
#' @param Categories categories labels to be plotted in the legend.
#' @param na.as.category Treat \code{NA} as a separate category? If `\code{TRUE}, NA will also appear in the legend as one of the categories.
#'
#' @return a map
#' @export
#'
#' @importFrom rnaturalearth ne_countries
#' @importFrom countrycode countrycode
#' @importFrom dplyr "%>%" left_join select select filter mutate relocate
#' @importFrom ggplot2 ggplot geom_sf theme labs scale_fill_viridis_d coord_sf xlab ylab ggtitle
#'                     aes unit element_text element_blank element_rect geom_text ggsave
#' @importFrom sf st_centroid st_coordinates
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
                         longitude = c(-180, 180) ,latitude = c(-90, 90),
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
    scale_fill_viridis_d(option = palette_option, begin= 0.3, na.value = 'grey80', direction= 1,
                         labels= c(Categories, "NA"), na.translate = na.as.category)+
    coord_sf(xlim= longitude, ylim= latitude, expand= FALSE, label_axes = 'SW') +
    xlab('')+ ylab('')+
    ggtitle(title)

  if (annote == TRUE) {

    world_points <- geometries_data(exclude.iso.na = T,
                                    countries.list = simdata$iso_a2[!is.na(simdata$MapFiller)])

    wplot <- wplot +
      geom_text(data= world_points, aes(x=X, y=Y,label= iso_a2), size= 2/div, color= 'black', fontface= 'bold')
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
