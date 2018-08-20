debug_message_l2("adding validate_ymd_hms()")

validate_ymd_hms <- function(chr_dt) {
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
  
  dt
}