worldplot(data = testdata1,
          ColName = "IntVal",
          CountryName = "countrycode",
          CountryNameType = "isoa2",
          rangeVal = c(0,100),
          latitude = c(0,45), longitude = c(-10,50),
          palette_option = c("red", "lightyellow", "green"),
          legend.position = "right",
          annote = TRUE, label.color = "black", label.size = 3)

worldplot(data = testdata1c,
          ColName = "value",
          CountryName = "iso_a2",
          CountryNameType = "isoa2",
          latitude = c(30,70), longitude = c(-15,40))

worldplot(data = testdata1c,
          ColName = "value",
          CountryName = "iso_a2",
          CountryNameType = "isoa2",
          rangeVal = c(0,100),
          latitude = c(5350000, 1000000), longitude = c(2500000, 6900000),
          crs = 3035)

worldplot(data = testdata1c,
          ColName = "value",
          CountryName = "iso_a2",
          CountryNameType = "isoa2",
          rangeVal = c(0,100),
          latitude = c(5350000, 1000000), longitude = c(2500000, 6900000),
          crs = 3035, annote = TRUE, transform_limits = FALSE)

worldplot(data = testdata1c,
          ColName = "value",
          CountryName = "iso_a2",
          CountryNameType = "isoa2",
          rangeVal = c(0,100),
          latitude = c(35, 70), longitude = c(-15,50), annote = T,
          shadows = T, label.color = "white", label.size = 3.5)

worldplot(data = data.frame(country = c("UK", "DK", "IT"), values = c(2,13,15)),
          ColName = "values",
          CountryName = "country",
          CountryNameType = "isoa2",
          rangeVal = c(0,16),
          latitude = c(35, 70), longitude = c(-15,50), annote = T,
          shadows = T, label.color = "white", label.size = 3.5,
          UK_as_GB =F)
