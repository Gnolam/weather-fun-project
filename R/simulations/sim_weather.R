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
#'
#' @return list object. in v1 just temperature inside
#' @export
#'
#' @examples
sim_weather <- function(
    chr_dt = NULL, 
    dt = NULL,
    coord = list(
      lat = 0, # -90..+90
      lon = 0, # -90..+90
      alt = 0  # 0..9000 (in meters)
    )
  ){
  # Hi!
  debug_message_l2("~> sim_weather()")
  

  # Select one of 2 options which will be used for input
  if (!is.null(chr_dt)) { 

# The function will use char argument -------------------------------------
    # Enforce the correct type of the argument
    stopifnot(class(chr_dt) == 'character')
    
    # 'safe' relationship IS important
    res.status <- tryCatch({
      # This place is one of the most 'fragile' usually  
      dt <- lubridate::ymd_hms(chr_dt)
      
      # It is possible that dt still does not produce the correct datetime
      if (is.na(dt)) {
        sys_err_msg <- "ymd_hms() did not recognize the date-time object"
        FALSE
      } else {
        TRUE
      }
    },
    error = function(e) {
      sys_err_msg <- e$message
      FALSE
    })

    # This is the fatal error, though we could advise user how to make it 'right'
    if (!res.status) {
      base::message(paste0(
        "\n\n",
        "Error: sim_weather() failed as date input is not in `ymd_hms` format\n",
        "Example of the date in an acceptable format: '2018-02-17 01:05:11'\n",
        "The input provided: '", chr_dt, "'\n",
        "-----------------------------------------\n",
        "Technical error message: ", sys_err_msg, "\n" 
      ))
      stop("CP01: Unaccaptable argument in sim_weather()")
    }
    
    
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
  temperature_daily <- predict(cfg$fit$daily, data.frame(x = rel_hour_within_day + 24))
  


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
  
  

# Adding stochastic -------------------------------------------------------
  # It is specific for each station
  annual_shift <- runif(
    n = 1,
    min = -cfg$stochastics$annual$shift,
    max = cfg$stochastics$annual$scale
  )
  
  annual_scale <- runif(
    n = 1,
    min = -cfg$stochastics$annual$scale,
    max = cfg$stochastics$annual$scale
  ) + 1
  
  daily_scale <- runif(
    n = 1,
    min = -cfg$stochastics$daily$scale,
    max = cfg$stochastics$daily$scale
  ) + 1
  
  
# pack into final temperature estimation ----------------------------------
  final_temperature_prediction <-
    temperature_annual * annual_scale + annual_shift
    temperature_daily  * daily_scale +
    temperature_latitude +
    temperature_altitude
  
  final_temperature_prediction %<>% round(digits = 1)
  
  return(final_temperature_prediction)
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
