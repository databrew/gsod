% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/put_data_in_db.R
\name{put_data_in_db}
\alias{put_data_in_db}
\title{Put data in db}
\usage{
put_data_in_db()
}
\value{
Data read from local files and appended to the gsod table of the gsod psql database
}
\description{
Read all the op.gz files from gsod/ftp.ncdc.noaa.gov/pub/data/gsod/<year>/<day-location-files>, and load into a psql database named gsod
}
