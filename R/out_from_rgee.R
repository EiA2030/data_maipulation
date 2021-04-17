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

####################################################################################################################################
#######                                               some examples                                      
####################################################################################################################################



srad.col <- format2tbl(url = "https://storage.googleapis.com/iita_transform_bucket/points_srad__2021_04_14_10_42_31.geojson", attribute = "srad_J/m2")
prec.col <- format2tbl(url = "https://storage.googleapis.com/iita_transform_bucket/points_prec__2021_04_14_10_42_35.geojson", attribute = "prec_mm")

dmerge = function(x,y) merge(x,y,all=TRUE, no.dups = TRUE)
weather <- Reduce(dmerge,list(srad.col,tmin.col,tmax.col,vapr.col,windU.col,windV.col))
