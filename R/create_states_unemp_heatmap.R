#' Creates a heatmap of the United States Unemployment Rate using the latest available information of unemployment rates.
#'
#' @param fred_key
#'
#' @return A PNG
#' @export
#'
#' @examples
#' create_states_unemp_heatmap
create_states_unemp_heatmap <- function(
    fred_key = fredKey
) {


  # Setting FRED API Key
  fred_key <- gsub("\"", "", fred_key)
  fredr::fredr_set_key(fred_key)

  # Downloads latest states unemployment figure. It might not be from
  # the same month.
  states_ur <- get_unemployment(geography = 'State', latest = TRUE) |>
    transform_to_tsibble() |>
    dplyr::select(-USUR) |>
    tidyr::pivot_longer(-date, names_to = "series_id") |>
    dplyr::transmute(date = date,
            unemployment = value,
            abb = substr(series_id, start = 1, stop = 2),
            name = cdlTools::fips(abb, to = "Name"))

  # Downloads latest US unemployment figure
  UR <- get_unemployment(geography = 'State', latest = TRUE) |>
    transform_to_tsibble() |> pull(USUR)

  states_data <- states_ur |>
    dplyr::mutate(estimate = unemployment - UR)

  # For 2021, I'm using ACS 1-year.
  states_geo <- tidycensus::get_acs(
    geography = "state",
    variables = c(households2021 = "B11012_001"),
    survey = "acs1",
    year = 2021,
    state = c(state.abb,"DC","PR"),
    geometry = TRUE,
    cache_table = TRUE,
    output = "wide"
  )
  states_geo <- tigris::shift_geometry(states_geo)
  states_geo <- states_geo |> dplyr::mutate(name = NAME)


states_map <- states_geo %>% dplyr::inner_join(states_data)




tmap::tmap_options(check.and.fix = TRUE)
statesMap <- states_map |> tmap::tm_shape() +
  tmap::tm_borders(col = "white") +
  tmap::tm_text("abb", size = .4, auto.placement = TRUE) +
  tmap::tm_fill("estimate", title = paste0("Percentage Points from the National ",
                                     UR,"% Unemployment Rate"),style = "fixed",
          breaks = c(-Inf,-1,-.5,0,.5,1,1.5,Inf),
          textNA = "Dunno",
          colorNA = "green",   # <-------- color for NA values
          palette = c("#C77417", "#FDAF54", "#E6C8A5", "#6ECCF9", "#2A9BCE", "#136598","#0F3562"),
          midpoint = NA,
          legend.is.portrait = FALSE) +
  tmap::tm_layout(
    frame = FALSE,
    legend.outside = TRUE,
    legend.outside.position = ("top"),
    legend.outside.size = .15,
    legend.text.size = .5,
    legend.text.fontface = "plain",
    legend.title.fontface = "italic",
    legend.width = .5,
    legend.height = .5,
    legend.stack = "horizontal",
    bg.color = "white",
    legend.title.size=1,
    main.title = "Unemployment Rate Differential",
    fontface = "bold",
    fontfamily = "serif"
  )
tmap::tmap_save(statesMap, "states_map.png", width=6, height=4, dpi = 600)

}
