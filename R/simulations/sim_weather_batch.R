

sim_weather_1_station <- function(
  IATA_code,
  dt
) {
# Hi!
  #stopifnot(IATA)
  # externalise validate / convert time
  

# locate station in DB ----------------------------------------------------
  stations_match <- cfg$stations %>% 
    filter(IATA == IATA_code)

# Check if the result is unique and if any --------------------------------
  stations_match_number <- dim(stations_match)[[1]]
  stopifnot(stations_match_number == 1)
  
# Only 1 match found, proceed ---------------------------------------------
  coord <- list(
    lat = stations_match$Lat,
    lon = stations_match$Lon,
    alt = stations_match$Alt
  )
  
  sim_weather(dt = dt, coord = coord)
}


# Debug section -----------------------------------------------------------

if (0) {
  if (1) {
    IATA_code <- 'SYD'
  }
  
  
  sim$sim_weather_1_station(
    dt = ymd_hms("2018-02-17 01:05:11"),
    IATA_code = "SYD")
}
