#' Put data in db
#' 
#' Read all the op.gz files from gsod/ftp.ncdc.noaa.gov/pub/data/gsod/<year>/<day-location-files>, and load into a psql database named gsod
#' @return Data read from local files and appended to the gsod table of the gsod psql database
#' @export

put_data_in_db <- function(){
  require(dplyr)
  require(RPostgreSQL)
  # connect to db
  drv <- dbDriver("PostgreSQL")
  # creates a connection to the postgres database
  # note that "con" will be used later in each connection to the database
  res <- try(con <- dbConnect(drv, dbname = "gsod",
                              host = "localhost", port = 5432),
             silent = TRUE)
  if(class(res) == "try-error"){
    stop('You need to create a psql database named gsod before moving forward.')
  }
  
  op.gzs <- dir('gsod', recursive = TRUE)
  op.gzs <- op.gzs[grepl('op.gz', op.gzs, fixed = TRUE)]
  # Map urls which are already in the db
  urls_in_db <- dbGetQuery(con, paste0("select distinct url from gsod"))
  urls_in_db <- urls_in_db %>% .$url
  for (i in 1:length(op.gzs)){
    message(i, ' of ', length(op.gzs))
    this_url <- op.gzs[i]
    # Test to see if this url is already in the table
    in_table <- this_url %in% urls_in_db
    if(!in_table){
      this_file <- paste0('gsod/', this_url)
      formatted <- GSODR::reformat_GSOD(file_list = this_file)
      names(formatted) <- tolower(names(formatted))
      # Keep only relevant vars
      formatted <- formatted %>%
        dplyr::select(yearmoda,
                      temp,
                      max,
                      min,
                      prcp,
                      usaf,
                      wban,
                      stnid,
                      stn_name,
                      ctry,
                      lat,
                      lon,
                      elev_m,
                      dewp,
                      visib,
                      wdsp,
                      mxspd) %>%
        rename(date = yearmoda)
      formatted$url <- this_url
      dbWriteTable(con, "gsod", 
                   value = formatted, append = TRUE, row.names = FALSE)
    } else {
      message(this_url, ' is already in database. Skipping.')
    }
  }
}
