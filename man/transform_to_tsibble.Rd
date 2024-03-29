% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transform_to_tsibble.R
\name{transform_to_tsibble}
\alias{transform_to_tsibble}
\title{It transforms an xts object to a tsibble}
\usage{
transform_to_tsibble(data = xts_obj)
}
\arguments{
\item{xts_obj}{The xts object to transform}
}
\value{
A tsibble
}
\description{
It transforms an xts object to a tsibble
}
\examples{
data_tsibble <- get_unemployment() |> transform_to_tsibble()
}
