debug_message_l2("adding process_single_task()")

process_single_task <- function(fname) {
  # Hi!
  debug_message_start("process_single_task(",fname,")")
  

# Reading the task --------------------------------------------------------
  # Just in case
  stopifnot(file.exists(fname))
  
  current_task <- jsonlite::fromJSON(fname)


# Extracting params -------------------------------------------------------
  # If format is not acceptable it should stop the process
  dt <- fn$validate_ymd_hms(current_task$from_date_time)

  
  # maximum 100,000 suggested
  num_steps <- current_task$number_of_steps
  stopifnot(class(num_steps) %in% c("integer", "numeric"), num_steps > 0, num_steps < 1e5)
  
  # Filename should be present and valid
  fname_output <- paste0(
    cfg$io.folder$output,
    current_task$file_name)
  
  stopifnot(class(current_task$file_name) == "character")



# try to create the file as a test for valid file name --------------------
  if (!file.create(fname_output))
    stop(paste0("Cannot create requred file: ", fname_output))

  if (!file.remove(fname_output))
    stop(paste0("Cannot remove temporary file: ", fname_output))
  
    
  
# detecting time period and converting it into interval -------------------
  step_size <- current_task$step_size
  
  stopifnot(
    class(step_size) == "character",
    step_size %in% c("days", "mins", "secs", "hours", "months", "years"))
  
  step_size_interval <- lubridate::period(num = step_size, units = step_size)
  
  
  params <- list(
    dt = dt,
    num_steps = step_size_interval,
    step_size = step_size
  )
  
  res <- sim$sim_weather_batch(
    list_of_stations = "_ALL_",
    params = params
  ) 
  

# Exporting the results ---------------------------------------------------
  res %>% write_csv(
    path = fname_output,
    col_names = TRUE 
    
  )  
    
    
  debug_message_end("process_single_task()\n")
}


# Debug section -----------------------------------------------------------

if (0) {
  if (1) {
    fname <- task_list[1]
    fname <- task_list[3]
    }
  
  if (1) {
    current_task <- list(
      file_name = "test.csv",
      csv_header = TRUE,
      from_date_time = "2018-02-17 01:05:11",
      number_of_steps = 120,
      step_size = "secs"
    )
    
    current_task %>% 
      jsonlite::toJSON(pretty = TRUE) %>% 
      write(file = "./io/task/a.json")
    
  }
  
  
  
}
