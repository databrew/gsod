#' Update database
#' 
#' Update the database with the most recent data
#' @return Data downloaded via ftp, and uploaded into to database
#' @export
update_db <- function(){
  require(dplyr)
  require(RPostgreSQL)
  # connect to db
  con <- src_postgres(dbname = 'gsod',
                      host = 'localhost',
                      port = 5432)
  # get max date in database
  max_date <- tbl(src = con, 
                  from = sql('SELECT DISTINCT MAX(date) FROM gsod')) %>%
    collect() %>% .$max
  max_year <- as.numeric(format(max_date, '%Y'))
  this_year <- as.numeric(format(Sys.Date(), '%Y'))
  get_new <- sort(unique(max_year:this_year))
  for (i in 1:length(get_new)){
    this_year <- get_new[i]
    get_data(this_year)
  }
  put_data_in_db()
}
