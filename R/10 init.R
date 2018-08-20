base::message("Initializing DebugMessageR...")
debug_message_reset_intent()


debug_message_start("10 init.R >>")

options(stringsAsFactors = FALSE)


# Create output folders ---------------------------------------------------
fn$dir.create_if_does_not_exist(cfg$io.folder$input, clean_it = FALSE)
fn$dir.create_if_does_not_exist(cfg$io.folder$tasks, clean_it = FALSE)
fn$dir.create_if_does_not_exist(cfg$io.folder$output, clean_it = TRUE)

# Create lm() fit objects -------------------------------------------------

cfg$fit <- list(
  annual = fit$temperature_annual_fit_poly_init(),
  daily =  fit$temperature_daily_fit_poly_init()
)

cfg$stations <-
  suppressMessages(
    read_csv("./io/input/weather_stations.csv")
  )


debug_message_end("10 init.R <<\n\n")
