debug_message_l2("adding sim_weather_1_station()")

#' Part of the batch processing. Processes single station
#'
#' @param dt_sequence vector of dates
#' @param IATA_code 3 character primary key for station table
#'
#' @return
#' @export
#'
#' @examples
sim_weather_1_station <- function(
  IATA_code,
  dt_sequence
) {
  # Hi!
  debug_message_l2("~> sim_weather_1_station(", IATA_code, ")")
  
  
  # Quickly check for type consistency --------------------------------------
  stopifnot(
    class(IATA_code) == "character",
    length(IATA_code) == 1
  )
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
  
  
  # combining result --------------------------------------------------------
  station_result <- NULL  
  for (i in 1:length(dt_sequence)) {
    dt <- dt_sequence[i]
    point.result <-
      sim_weather(
        dt = dt,
        coord = coord,
        random_factor = random_factor)
    
    if (is.null(station_result)) {
      # 1st record
      station_result <- point.result
    } else {
      station_result %<>% rbind(point.result)
    }
  #  cat(".")
  }
  #cat("\n")
  
  station_result %<>%
    mutate(
      triplet = paste0(
        stations_match$Lat %>% round(digits = 2),",",
        stations_match$Lon %>% round(digits = 2),",",
        stations_match$Alt %>% round(digits = 0)
      ),
        station = IATA_code      
      )
  
  station_result
}
