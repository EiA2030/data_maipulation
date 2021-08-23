tidy.noaa <- function() {
  require(sf)
  require(terra)
  require(geodata)
  n <- 1
  # for (band in c("srad", "prec", "wind", "temp", "tmax", "tmin", "vapr")) {
  # for (band in list.dirs(path = ".", full.names = TRUE, recursive = TRUE)) {
  for (band in c("srad", "prec")) {
    files <- list.files(paste0("NOAA_data/process/", band), pattern = paste0("noaa_", band), full.names = TRUE)
    s.year <- substr(files[1], nchar(files[1])-20, nchar(files[1])-17)
    s.month <- substr(files[1], nchar(files[1])-16, nchar(files[1])-15)
    s.day <- substr(files[1], nchar(files[1])-14, nchar(files[1])-13)
    e.year <- substr(files[length(files)], nchar(files[length(files)])-20, nchar(files[length(files)])-17)
    e.month <- substr(files[length(files)], nchar(files[length(files)])-16, nchar(files[length(files)])-15)
    e.day <- substr(files[length(files)], nchar(files[length(files)])-14, nchar(files[length(files)])-13)
    dates <- seq(as.Date(as.character(paste0(s.year,s.month,s.day)), format="%Y%m%d"),
                 as.Date(as.character(paste0(e.year,e.month,e.day)), format="%Y%m%d"), by = "day")
    x <- rast(files)
    v <- gadm("KEN", level=2, tempdir(), version=3.6) # optional?
    v <- st_union(st_as_sf(v[v$NAME_1 == "Tana River"])) # optional?
    v.grid <- v %>%
      st_make_grid(cellsize = 0.083300000000000, what = "centers") %>% # grid of points
      st_intersection(v)
    v.x.grid <- terra::extract(x, vect(v.grid), xy = TRUE)
    v.x.grid <- v.x.grid[ , !(names(v.x.grid) %in% c("ID"))]
    colnames(v.x.grid) <- c(as.character(dates), "x", "y")
    test <- reshape(v.x.grid,
                    direction = "long",
                    varying = list(names(v.x.grid)[!(names(v.x.grid) %in% c("x", "y"))]),
                    v.names = paste0(band),
                    idvar = c("x", "y"),
                    timevar = "date",
                    times = as.character(dates))
    if (n == 1) {noaa <- test} else {noaa <- merge(noaa, test, by = c("x", "y", "date"))}
    assign("noaa", noaa, envir = .GlobalEnv)
    n <- n + 1
  }
  as.Date(noaa$date, format = "%Y-%m-%d")
}
tidy.noaa()
