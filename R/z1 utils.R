
# Init --------------------------------------------------------------------

base::message("Adding system functions...")

# Util functions
sys <- new.env()

# -  ----------------------------------------------------------------------
base::message("  adding sys$source_Rs() v2")
sys$source_Rs <- function(folder, env = .GlobalEnv){
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


# - -----------------------------------------------------------------------

base::message("  adding sys$sessionInfo()")
sys$sessionInfo <- function(){
  debug_message_l2("~> fn.sessionInfo()")

  sessionInfo() %>%
    capture.output() %>%
    print()

  base::message("")
}



# -  ----------------------------------------------------------------------


base::message("  adding sys$install_packages_if_needed()")

sys$install_packages_if_needed <-
  function(packages){
    
    # Check if input is of required type --------------------------------------
    # Same for single value and c-vector
    stopifnot(class(packages) %in% ('character'))
    
    
    # Check if package(s) are in the system -----------------------------------
    packages.missing <-
      packages[!(packages %in% installed.packages()[, "Package"])]
    
    
    # If any packages missing pls install them --------------------------------
    if (length(packages.missing)) {
      cat("List of packages to be installed: '", paste0(packages.missing, collapse = "', '"), "'\n")
      install.packages(packages.missing, quiet = T)
    }
    
  }


# -  ----------------------------------------------------------------------

base::message("  adding sys$install_GitHub_package_if_needed()")

sys$install_GitHub_package_if_needed <-
  function(package, github_path){
    # Check if inputs are of required type --------------------------------
    stopifnot(class(package) %in% ('character'))
    stopifnot(class(github_path) %in% ('character'))
    stopifnot(length(package) == 1)
    
    
    # Check if a package is already installed ---------------------------------
    if(!(package %in% installed.packages()[, "Package"]))
    {
      base::message(paste0("GitHub dependant package '", package ,"' is not installed\nPreparing to install"))
      
      # In order to install the GitHub package you need to install 'devtools' first
      install_packages_if_needed("devtools")
      
      # No need to lcoal try-catch error here as it will be fatal and should terminate the whole process
      devtools::install_github(github_path)
    }
  }

base::message("Done\n")


# Debug section -----------------------------------------------------------

if (0) {
  packages <- list_of_required_packages
}
