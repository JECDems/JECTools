% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_states_clickable_map.R
\name{create_states_clickable_map}
\alias{create_states_clickable_map}
\title{Creates a Clickable Map of the United States}
\usage{
create_states_clickable_map(
  states_urls = choose.files(caption = "Select CSV file containing State URLs", multi =
    FALSE),
  fred_key = readline(prompt = "Enter FRED API Key: ")
)
}
\arguments{
\item{states_urls}{A CSV File containing the URLs for state fact sheets}

\item{fred_key}{A FRED API Key}
}
\value{
an HTML Map
}
\description{
Creates a Clickable Map of the United States
}
\examples{
create_states_clickable_map()
}