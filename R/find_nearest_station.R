#' Find nearest station
#' 
#' Find the nearest station given a string named location
#' @param location
#' @param lon
#' @param lat
#' @param n The number of stations to return, in order of distance
#' @return A character vector of length 1
#' @export
find_nearest_station <- function(location = NULL,
                                 lon = NULL,
                                 lat = NULL,
                                 n = 1){
  require(GSODR)
  # require(ggmap)
  require(photon)
  require(dplyr)
  by_location <- !is.null(location)
  if(!by_location){
    if(is.null(lon) | is.null(lat)){
      stop('Either the location or both the lon and lat arguments must be non NULL')
    }
  }
  
  if(by_location){
    coords <- geocode(location)
    if(!is.null(lon) | !is.null(lat)){
      warning('Ignoring lon and lat, since a location was provided.')
    }
    if(nrow(coords) == 0){
      stop('No location found.')
    }
    coords <- coords[1, c('lon', 'lat')]
    lon <- coords$lon
    lat <- coords$lat
  }
  if(is.na(lon) | is.na(lat)){
    stop('Unable to find coordinates.')
  }
  
  # Modified nearest station searcher from GSODR package
  near <- function(LAT, LON, n){
    isd_history <- NULL
    load(system.file("extdata", "isd_history.rda", package = "GSODR"))
    # Keep only those in gsod 2016 data
    isd_history <-
      isd_history %>%
      filter(STNID %in% gsod2016$stnid)
    haversine_distance <- function(lat1, lon1, lat2, lon2) {
      lat1 <- lat1 * pi/180
      lat2 <- lat2 * pi/180
      lon1 <- lon1 * pi/180
      lon2 <- lon2 * pi/180
      delta_lat <- abs(lat1 - lat2)
      delta_lon <- abs(lon1 - lon2)
      6371 * 2 * asin(sqrt((sin(delta_lat/2))^2 + cos(lat1) * 
                             cos(lat2) * (sin(delta_lon/2))^2))
    }
    nearby <- haversine_distance(isd_history["LAT"], isd_history["LON"], 
                                 LAT, LON) %>%
      dplyr::rename(km = LAT)
    out <- isd_history %>% cbind(nearby) %>% dplyr::arrange(km)
    out <- out[1:n,] 
    names(out) <- tolower(names(out))
    out <- out %>% dplyr::select(stnid, lon, lat, km, stn_name)
    return(out)
  }
  
  out <- near(LAT = lat, LON = lon, n = n)
  # 
  # not_found <- TRUE
  # counter <- 0
  # message('Looking for stations near \n--longitude: ', lon, '\n--latitude: ', lat)
  # 
  # while(not_found){
  #   message('---Searching at ', counter, ' kilometers from location.')
  #   stations <- 
  #     nearest_stations(LAT = lat,
  #                      LON = lon, 
  #                      distance = counter)
  #   if(length(stations) > 0){
  #     not_found <- FALSE
  #     message('\nFound at ', counter, ' kilometers from location!')
  #   } else {
  #     counter <- counter + 1
  #   }
  # }
  # out <- data_frame(stnid = stations[1],
  #                   lon,
  #                   lat, 
  #                   km = counter)
  # if(!is.null(location)){
  #   the_location = location
  #   out <- out %>% mutate(location = the_location)
  # }
  # return(out)
}
