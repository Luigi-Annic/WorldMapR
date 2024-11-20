worldplot(data = testdata1,
          ColName = "IntVal",
          CountryName = "countrycode",
          CountryNameType = "isoa2",
          rangeVal = c(0,100),
          latitude = c(0,45), longitude = c(-10,50),
          palette_option = c("red", "lightyellow", "green"))

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
          crs = 3035, annote = TRUE)
