if(1){
  rm(list=ls())
  gc()
  cat("\014")  

ver.num <- "0.01 " # should be 5 symbols
  
base::message("     ******************************************************")
base::message("    ***                                                ***")
base::message(paste0("   ***  Main title here                       v.", ver.num, " ***"))
base::message("  ***    comment                                     ***")
base::message(" ***                                                ***")
base::message("******************************************************")
}




res.status <- tryCatch({ 

# Load configs and name spaces --------------------------------------------
  source("R/00 library.R")
  source("R/z1 utils.R")

  # Project params
  fn.source_Rs("R/config/", cfg <- new.env())

  # Misc functions
  fn.source_Rs(folder =  "R/misc", fn <- new.env())

  source("R/10 init.R")

  
  
  #source("R_modules/20 something important.R")
  
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
