# Clear scren
cat("\014")  

debug_message_start("20 Task processing >>")

task_list <- list.files(
  path = cfg$io.folder$tasks,
  pattern = "*.json",
  full.names = T
  )

task_count <- length(task_list)

if ( task_count == 0) {
  # Nothing to do here, boring...
  debug_message_l2("No tasks found... Exiting")
} else {
  # Great, some tasks files found
  debug_message_l2(task_count, " task(s) found. Commencing")
  
  for (task_i in 1:task_count) {
    sim$process_single_task(task_list[task_i])
  }
  
}
  

  
debug_message_end("20 Task processing <<")