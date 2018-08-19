
base::message("adding fn.source_Rs() v2")
fn.source_Rs <- function(folder, env = .GlobalEnv){
  debug_message_start("fn.source_Rs( ",folder," ) >>")
  a<-sapply(
    list.files(
      folder,
      pattern="*.R",
      full.names=TRUE,
      recursive = TRUE,
      ignore.case=TRUE),
      source,# .GlobalEnv)
      env
   )
  
  debug_message_end("fn.source_Rs() <<\n")
}


base::message("adding fn.sessionInfo()")
fn.sessionInfo <- function(){
  debug_message_l2("~> fn.sessionInfo()")

  sessionInfo() %>%
    capture.output() %>%
    print()

  base::message("")
}