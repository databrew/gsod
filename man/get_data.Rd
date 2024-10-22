% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_data.R
\name{get_data}
\alias{get_data}
\title{Get data}
\usage{
get_data(years = 2000:2017)
}
\arguments{
\item{years}{A numeric vector of years for which data should be fetched}
}
\value{
op.gz files will be saved to gsod/ftp.ncdc.noaa.gov/pub/data/gsod/<year>/<day-location-files>
}
\description{
Get data from the GSOD
}
