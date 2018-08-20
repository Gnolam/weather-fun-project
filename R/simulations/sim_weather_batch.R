debug_message_l2("adding sim_weather_batch()")

# main function -----------------------------------------------------------

#' Loop through the stations and produce simulations for all of them
#'
#' @param list_of_stations currently only "ALL" is supported trough JSON
#' @param params expexts dt, num_steps, step_size
#'
#' @return
#' @export
#'
#' @examples
sim_weather_batch <- function(
  list_of_stations = "_ALL_", # "_ALL_" means for all stations
  params
) {
  # Hi!
  debug_message_l2("sim_weather_batch(", paste0(list_of_stations, collapse = ", "), ")")


# Genrate sequence of dates -----------------------------------------------
  dt_sequence <- seq(
    params$dt,
    params$dt %m+% params$num_steps,
    by = params$step_size)
  

# Generate sequence of stations -------------------------------------------
  satition_sequence <- list_of_stations
  if (length(list_of_stations) == 1) {
    if (list_of_stations == "_ALL_") {
      satition_sequence <- cfg$stations$IATA
    }
  }
  

# Loop and merge ----------------------------------------------------------

  # Purrr and lapply constructions are not used because
  # - they are more difficult to debug
  # - no gain in efficiency in this particular case
  
  all_stations_result <- NULL
  
  for (station in satition_sequence) {
    # station <- satition_sequence[1]
    station_result <- sim_weather_1_station(
      IATA_code = station,
      dt_sequence = dt_sequence
      )
    
    # Stack the results
    if (is.null(all_stations_result)) {
      # 1st entry
      all_stations_result <- station_result
    } else {
      # Stack to previous
      all_stations_result %<>% rbind(station_result)
    }
  }
  all_stations_result
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
  
  params <- list(
    dt = ymd_hms("2018-02-17 01:05:11"),
    num_steps = days(5),
    step_size = "1 day"
  )
  list_of_stations <- c("_ALL_")
  
  res <- sim_weather_batch(
    list_of_stations = list_of_stations,
    params = params
  )
}
