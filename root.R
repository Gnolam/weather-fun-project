if (1) {
  rm(list = ls())
  gc()
  cat("\014")  

ver.num <- "0.07 " # should be 5 symbols
  
base::message("     ******************************************************")
base::message("    ***                                                ***")
base::message(paste0("   ***  The Weather fun project               v.", ver.num, " ***"))
base::message("  ***    implementing [2].sp7 card                   ***")
base::message(" ***                                                ***")
base::message("******************************************************")
}




res.status <- tryCatch({ 

# Load configs and name spaces --------------------------------------------
  source("R/z1 utils.R")

  # Load libraries
  source("R/00 library.R")
  
  # Project params
  sys$source_Rs("R/config/", cfg <- new.env())

  # Misc functions
  sys$source_Rs(folder =  "R/misc", fn <- new.env())

  # All functions related to curve fitting and approximation
  sys$source_Rs(folder =  "R/fit", fit <- new.env())
  

  # All functions related to curve fitting and approximation
  sys$source_Rs(folder =  "R/simulations/", sim <- new.env())
  
  
# Main sequence -----------------------------------------------------------

  source("R/10 init.R")

  
  source("R/[XX] Current unstructured tests.R")
  
  
  TRUE
},
error = function(e) {
  cat("\n\n**************************************************\n")
      cat("!!!      Terminating due to unprocessed error  !!!")
  cat("\n**************************************************\n")
  
  cat(e$message, '\n')
  
  FALSE
})


if (!res.status) {
  # Oops, error detected
  fn.sessionInfo()
  
  # Stop is important here as external schedulers need to be aware 
  #   of the unprocessedfatal error
  stop("Something went wrong. Please check logs\n")

} else {
  gc()
  base::message("Job's done,\n\tenjoy!\n\n") 
}





# debug_message_l2("Starting shiny app...")
# shinyApp(f.ui$ui, f.srv$server)
