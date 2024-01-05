worldplot(data = testdata1b,
          div = 1,
          ColName = "VNum",
          CountryName = "Cshort",
          CountryNameType = "isoa2",
          rangeVal = c(0,50),
          annote = FALSE#,
          #save = TRUE,
          #path = "C:/Users/luigi/Desktop/spaz"
          )

worldplot(data = testdata1b,
          div = 0.5,
          ColName = "VNum",
          CountryName = "Cshort",
          CountryNameType = "isoa2",
          rangeVal = c(0,50),
          annote = TRUE,
          longitude = c(-25, 44),
          latitude = c(35, 72),
          title = "Focus on a section of the map, with annotations",
          legendTitle = "Rand. Vals",
          #save = TRUE,
          #path = "C:/Users/luigi/Desktop/spaz",
          #filename = "worldplot10.jpg",
          #width = 5,
          #height = 5,
          #scale = 2,
          #units = "cm"
          )

