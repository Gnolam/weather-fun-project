base::message("Loading R libraries")



# Init --------------------------------------------------------------------
list_of_required_packages <- c(
  "readr",
  "dplyr",
  "stringr",
  "lubridate",
  "jsonlite",
  "magrittr",
  "tidyverse",
  "easypackages",
  "DebugMessageR"
)


# Packages which require special treatment --------------------------------
sys$install_GitHub_package_if_needed(
  "DebugMessageR", "Gnolam/DebugMessageR")


# Github packages must be installed by now --------------------------------
sys$install_packages_if_needed(list_of_required_packages)


# Load packages -----------------------------------------------------------
suppressMessages(suppressWarnings(
  easypackages::libraries(list_of_required_packages)))


# Clean garbage -----------------------------------------------------------
rm(list_of_required_packages)
# No need for gc() on this stage as it is too clow
