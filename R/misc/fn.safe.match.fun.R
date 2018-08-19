debug_message_l2("[misc] safe.match.fun() v2.1.a")
safe.match.fun <- function(name, env = .GlobalEnv, silent = TRUE, check_class = "function") {
  
  env.class <- class(env)
  
  if(!silent)
    debug_message_l3(
      "~> safe.match.fun() v2.1.a Looking for '", name, "()'",
      ifelse(
        env.class == "character",
        paste0("in `", env,"`"),
        "")
      )
  
  
  
  if(env.class == "character") {
    if(!exists(env, mode = "environment"))
      stop(str_c(
        "Environment '",
        env,
        "' IS referred but NOT found")
      )
    if(!silent)debug_message_l4("Getting access to ",env)
    env <- get(env, envir = .GlobalEnv)
  }
  
  
  stopifnot(class(env) == "environment")
  
  if(!exists(name, mode = check_class, envir = env))
    stop(str_c(
      "Function '",
      name,
      "' IS referred but NOT found")
      )
  
  if(!silent)debug_message_l4("Getting access to ",name)
  get(name,envir = env)
  #match.fun(name)
}




# Debug -------------------------------------------------------------------
if(0){
  env = rnr
  name = "fb.request"
}

if(0){
  
  exists("fb", mode = "environment")
  e <- get("fb",envir = .GlobalEnv)
  
  exists("fb.call", mode = "function", envir = e)
  fn <- get("fb.call",envir = e)
  fn(NULL)
}
