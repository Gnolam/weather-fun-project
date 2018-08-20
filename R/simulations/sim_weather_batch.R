

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

# generate stochastics ----------------------------------------------------

  # Adding stochastic -------------------------------------------------------
  # It is specific for each station
  random_factor <- list(
    annual_shift = runif(
      n = 1,
      min = -cfg$stochastics$annual$shift,
      max = cfg$stochastics$annual$scale
    ),
    
    annual_scale = runif(
      n = 1,
      min = -cfg$stochastics$annual$scale,
      max = cfg$stochastics$annual$scale
    ) + 1,
    
    daily_scale = runif(
      n = 1,
      min = -cfg$stochastics$daily$scale,
      max = cfg$stochastics$daily$scale
    ) + 1
  )
    
  
  sim_weather(dt = dt, coord = coord, random_factor = random_factor)
}


# Debug section -----------------------------------------------------------

if (0) {
  if (1) {
    IATA_code <- 'SYD'
  }
  
  
  sim$sim_weather_1_station(
    dt = ymd_hms("2018-02-17 01:05:11"),
    IATA_code = "SYD")
  
  sim$sim_weather_1_station(
    dt = ymd_hms("2018-07-17 00:05:11"),
    IATA_code = "HBA")
  
  if (1) {
    dt = ymd_hms("2018-07-17 01:05:11")
    IATA_code = "HBA"
  }
}
