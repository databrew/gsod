# library(gsod)
library(devtools)
library(dplyr)
library(RPostgreSQL)

# get_data(); put_data_in_db(); update_db()

# connect to db
con <- src_postgres(dbname = 'gsod')#,
                    # host = 'localhost',
                    # port = 5432)

years <- 2017:2019
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
    collect() 
  data_name <- paste0('gsod', this_year)
  assign(data_name,
         data.frame(x))
  save(list = data_name,
       file = paste0('../data/', data_name, '.rda'))
  # devtools::use_data(get(data_name),
  #                    overwrite = TRUE)
}

# library(gsod)
