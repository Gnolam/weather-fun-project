base::message("Loading R libraries")


# Dedine list of packages to be installed and loaded --------------------

list.of.packages <- c(
  "readr",
  "dplyr",
  "stringr",
  "lubridate",
  "purrr",
  "magrittr",
  "tidyverse"
)

list.of.packages_ext <- c("easypackages", list.of.packages)


# Install packages if not present in the system ---------------------------

#Get the list of packages which are NOT part of the current installation 
new.packages <-
  list.of.packages[!(list.of.packages_ext %in% installed.packages()[, "Package"])]

# If the length of the 'missing packages' is not empty, pls install them
if(length(new.packages))
  install.packages(new.packages)


# Load packages -----------------------------------------------------------
suppressMessages(suppressWarnings(
  libraries(
    list.of.packages
  )))



# Clean garbage -----------------------------------------------------------
rm(list.of.packages, list.of.packages_ext, new.packages)
# No need for gc() on this stage as it is too clow
