# Function to format outputs extracted from Google Earth Engine
format2tbl <- function(url, attribute){
  require(RCurl)
  require(data.table)
  require(sf)
  col <- data.table::data.table(read_sf(url))
  colnames(col) <- c("date", as.character(attribute), "deleteme","geo")
  col$date <- as.Date(substr(col$date, 1,8), "%Y%m%d")
  col <- cbind(col, st_coordinates(col$geo))
  col <- col[, c(1,2,5,6)]
  col <- col %>%
    setkey(date,X,Y)
  return(col)
}

# Function to merge the different outputs into one single object
dmerge <- function(x,y){
    m <- merge(x,y,all=TRUE, no.dups = TRUE)
    return(m)
}
