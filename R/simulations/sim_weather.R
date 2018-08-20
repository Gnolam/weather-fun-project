debug_message_l2("adding sim_weather() v1")


#' 'Main power' of the project
#' Currently v1
#' Functionality is defined by ticket [1].sp2:
#' - [ ] accept date-time
#' - [ ] proportion within year
#' - [ ] proportion within day
#'
#' @param chr_dt pass this param if it is more convenient to leave the checks to a function
#' @param dt a valid POSIXt date 
#' @param coord a list of 3 variables : lat, lon, alt. All numberic. 
#' @param random_factor specs of the randomness for temperature cals
#'
#' @return list object. in v1 just temperature inside
#' @export
#'
#' @examples
sim_weather <- function(
    chr_dt = NULL, 
    dt = NULL,
    coord = list(),
    random_factor = list()
  ){
  # Hi!
#  debug_message_l2("~> sim_weather()")
  

  # Select one of 2 options which will be used for input
  if (!is.null(chr_dt)) { 

# The function will use char argument -------------------------------------
    dt <- fn$validate_ymd_hms(chr_dt)
    
    
  } else {

# date object is being passed ---------------------------------------------
    # Enforce the correct type of the argument
    stopifnot(class(dt) == c("POSIXct", "POSIXt" ))
  }
  

# Check the feasibility of the coord --------------------------------------

  stopifnot(class(coord) == "list")
  stopifnot(
    class(coord$lat) %in% c("numeric", "integer"),
    !is.na(coord$lat),
    coord$lat <= 180,
    coord$lat >= -180
  )
  stopifnot(
    class(coord$lon) %in% c("numeric", "integer"),
    !is.na(coord$lon),
    coord$lon <= 180,
    coord$lon >= -180
  )
  stopifnot(
    class(coord$alt) %in% c("numeric", "integer"),
    !is.na(coord$alt),
    coord$alt <= 9000,
    coord$alt >= 0
  )
  
  

# Check random factor input -----------------------------------------------
  stopifnot(
    class(random_factor) == "list",
    class(random_factor$annual_shift) %in% c("numeric", "integer"),
    class(random_factor$annual_scale) %in% c("numeric", "integer"),
    class(random_factor$daily_scale) %in% c("numeric", "integer")
  )
  
  

# Relative position within month ------------------------------------------
  # Note: YEAR is ignored essentially
  
  # Find the 'relative position'
  rel_day_within_month <- (lubridate::day(dt) - 1) / (days_in_month(dt)) %>% as.numeric()
  rel_month <- lubridate::month(dt)  + rel_day_within_month
  
  # Pick the temperature withing annual curve
  # the shift by +12 is due to implementation of the poly fitting method
  temperature_annual <- predict(cfg$fit$annual, data.frame(x = rel_month + 12))

  
  
  
# Relative position within day --------------------------------------------
  # Find the 'relative position'
  rel_hour_within_day = 
    as.duration(
      interval(
        floor_date(dt,unit = "days"),
        dt)
      ) %/%
    as.duration(seconds(1))/3600
  
  # the shift by +24 is due to implementation of the poly fitting method
  relative_temperature_daily <- predict(cfg$fit$daily, data.frame(x = rel_hour_within_day + 24))
  


# lat, alt temperature modifiers ------------------------------------------
  # Take Sydney coord as a reference
  # lat -33.865143
  
  
  # Calculate difference vs. Sydney
  # Positive numver means closer to Equator and thus warmer
  # We ignore here presence of the deserts etc.
  # for each 1 degree in latitude we assume the temperature changes by .5 degree
  # Thus Darwin is ~10 warmer vs Sydney
  #   
  temperature_latitude <- (coord$lat + 33.865143) * cfg$latitude_modifier
  
  

# Altitude modifer --------------------------------------------------------
  # Formula is taken from: https://sciencing.com/tutorial-calculate-altitude-temperature-8788701.html
  temperature_altitude <- coord$alt / 1000 * cfg$altitude_modifier
  

  
# pack into final temperature estimation ----------------------------------
  final_temperature_prediction <-
    temperature_annual * random_factor$annual_scale + random_factor$annual_shift +
    relative_temperature_daily  * random_factor$daily_scale +
    temperature_latitude +
    temperature_altitude
  
  final_temperature_prediction %<>% round(digits = 1)
  

# Conditions --------------------------------------------------------------

  is_clear_weather <- runif(n = 1, min = 0, max = 100) > 25
  conditions_str <- ifelse(
    is_clear_weather,
    "Clear",
    ifelse(
      final_temperature_prediction > 0,
      "Rain",
      "Snow"
    )
  )

# Humidity ----------------------------------------------------------------

#  change in humidity is defined as proportional to 
#    negative change in temperature temperature
  humidity = (6 - relative_temperature_daily) * 10 

# If water falls from the sky... well, it should be WET  
  humidity <- ifelse(
    is_clear_weather,
    humidity,
    humidity + 20
  )
  
  # Cap for extreme values
  humidity <- max(0, humidity)
  humidity <- min(100, humidity)


# Pressure ----------------------------------------------------------------

  atm_pressure <- 
    1100 +                                     # base value
    runif(n = 1, min = -20,max = 20) +         # boring without random
    ifelse(is_clear_weather, 0, -100) +        # if rain then less
    coord$alt * cfg$pressure_altitude_decrease # should be dropping with height
     
  
  data.frame(
    local_time = dt,
    conditions = conditions_str,
    temperature = final_temperature_prediction,
    pressure = atm_pressure,
    humidity = humidity 
  )
}



# Debug section -----------------------------------------------------------

#lubridate::ymd_hms("2018-02-17T01:05:11Z")

if (0) {
  if (1) {
    chr_dt = "2018-02-17 01:05:11"
    dt = lubridate::ymd_hms("2018-02-17 01:05:11")
    
    dt <- lubridate::ymd_hms("2018-02-28 01:05:11")
    (lubridate::day(dt) - 1)/(days_in_month(dt))
  }

  if ( 0 ) {
    # Testing the function behaviour vs. various 'wrong' dates
    sim_weather("2018-02-17 01:05:111")
    sim_weather("1")
    sim_weather(1)
    sim_weather(dt)
    sim_weather(dt = dt)
  }
}
