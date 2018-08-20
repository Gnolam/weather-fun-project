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
#'
#' @return list object. in v1 just temperature inside
#' @export
#'
#' @examples
sim_weather <- function(
    chr_dt = NULL, 
    dt = NULL      
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
  


# Relative position within month ------------------------------------------
  # Note: YEAR is ignored essentially
  
  # Find the 'relative position'
  rel_day_within_month <- (lubridate::day(dt) - 1) / (days_in_month(dt)) %>% as.numeric()
  rel_month <- lubridate::month(dt)  + rel_day_within_month
  
  # Pick the temperature withing annual curve
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
  
  temperature_daily <- predict(cfg$fit$daily, data.frame(x = rel_hour_within_day + 24))
  

# pack into final temperature estimation ----------------------------------
  final_temperature_prediction <-
    temperature_annual + temperature_daily 
  
  return(final_temperature_prediction)
}



# Debug section -----------------------------------------------------------

#lubridate::ymd_hms("2018-02-17T01:05:11Z")

if (0) {
  if (1) {
    chr_dt = "2018-02-17 01:05:11"
    dt = lubridate::ymd_hms("2018-02-17 01:05:11")
    
    dt <- lubridate::ymd_hms("2018-02-28 01:05:11")
    (lubridate::day(dt)-1)/(    days_in_month(dt)-1)
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
