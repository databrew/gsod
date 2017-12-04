# library(gsod)
library(devtools)
library(dplyr)
library(RPostgreSQL)

# get_data(); put_data_in_db(); update_db()

# connect to db
con <- src_postgres(dbname = 'gsod',
                    host = 'localhost',
                    port = 5432)

years <- 2000:2017
for (i in 1:length(years)){
  this_year <- years[i]
  message(this_year)
  start_date <- paste0(this_year, '-01-01')
  end_date <- paste0(this_year, '-12-31')
  this_query <- paste0("SELECT * FROM gsod WHERE (date >= '",
                       start_date,
                       "' AND date <= '", end_date, "')")
  x <- tbl(src = con, 
           from = sql(this_query)) %>%
    group_by(ctry, date, lon, lat) %>%
    tally %>%
    collect() 
  data_name <- paste0('gsod', this_year)
  assign(data_name,
         x)
  save(list = data_name,
       file = paste0('../data/', data_name, '.rda'))
  # devtools::use_data(get(data_name),
  #                    overwrite = TRUE)
}

