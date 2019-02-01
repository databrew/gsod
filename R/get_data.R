#' Get data
#' 
#' Get data from the GSOD 
#' @param years A numeric vector of years for which data should be fetched
#' @return op.gz files will be saved to gsod/ftp.ncdc.noaa.gov/pub/data/gsod/<year>/<day-location-files>
#' @export
get_data <- function(years = 2000:2019){
  require(tidyverse)
  require(RCurl)
  if(!dir.exists('gsod')){
    dir.create('gsod')
  }
  owd <- getwd()
  setwd('gsod')
  for (i in 1:length(years)){
    this_year <- years[i]
    if(!dir.exists(paste0('ftp.ncdc.noaa.gov/pub/data/gsod/', this_year))){
      system(paste0('wget -m ftp://ftp.ncdc.noaa.gov/pub/data/gsod/', this_year))
    } else {
      message(this_year, ' already is on the hard drive. Skipping.\n---If you need to re-fetch data for this year, delete this folder: ', paste0('ftp.ncdc.noaa.gov/pub/data/gsod/', this_year))
    }
  }
}
    