worldplotCat(data = testdata1b,
             div = 1,
             ColName = "VCat",
             CountryName = "Cshort",
             CountryNameType = "isoa2",
             title = "Testing the function for Categorical variables",
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             annote = TRUE)


worldplotCat(data = testdata1b,
             div = 1,
             ColName = "VCat",
             CountryName = "Cshort",
             CountryNameType = "isoa2",
             title = "Testing the function for Categorical variables",
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             annote = TRUE)

worldplotCat(data = testdata1b,
             div = 1,
             ColName = "VCat",
             CountryName = "Cshort",
             CountryNameType = "isoa2",
             title = "Testing the function, custom colours",
             palette_option = c("#C3E2EA", "#58C0D0", "#256C91"),
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             annote = TRUE,
             na.as.category = F)

worldplotCat(data = testdata1c,
             ColName = "ValCat",
             CountryName = "iso_a2",
             CountryNameType = "isoa2",
             palette_option = c("#C3E2EA", "#58C0D0", "#256C91"),
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             latitude = c(5350000, 1000000), longitude = c(2500000, 6900000),
             crs = 3035, annote = TRUE, transform_limits = F)


worldplotCat(data = testdata1c,
             ColName = "ValCat",
             CountryName = "iso_a2",
             CountryNameType = "isoa2",
             palette_option = c("#C3E2EA", "#58C0D0", "#256C91"),
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             latitude = c(5350000, 1000000), longitude = c(2500000, 6900000),
             crs = 3035, annote = TRUE,
             na.as.category = F, transform_limits = F, label.color = "red", label.size = 5)

worldplotCat(data = testdata1c,
             ColName = "ValCat",
             CountryName = "iso_a2",
             CountryNameType = "isoa2",
             palette_option = c("#C3E2EA", "#58C0D0", "#256C91"),
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             latitude = c(30,62), longitude = c(-7, 70),
             crs = 3035, annote = TRUE, transform_limits = T,
             UK_as_GB = F)


worldplotCat(data = testdata1c,
             ColName = "ValCat",
             CountryName = "iso_a2",
             CountryNameType = "isoa2",
             palette_option = c("#C3E2EA", "#58C0D0", "#256C91"),
             Categories = c("Low", "Average", "High"),
             legendTitle = "CAT",
             latitude = c(30,82), longitude = c(-20, 70),
             annote = TRUE, UK_as_GB = T)
