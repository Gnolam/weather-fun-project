debug_message_l2("[XX] Current resting")

# tmp.res <- 
#   fit$sim_weather(
#     dt = lubridate::dmy_hms("2018-02-17 01:05:11")
#   )
cat( '[1].sp2 test output for `sim_weather("2018-02-17 01:05:11")`: ', sim$sim_weather("2018-02-17 01:05:11"), "\n")

cat(
  '[1].sp5 test output for `sim_weather(2018-02-17 01:05:11, SYD)`: ',
  sim$sim_weather_1_station(ymd_hms("2018-02-17 01:05:11"), IATA_code = "SYD"),
  "\n"
)




cat(
  '[1].sp5 test output for `sim_weather(2018-02-17 01:05:11, SYD)`: ',
  sim$sim_weather_1_station(ymd_hms("2018-08-17 01:05:11"), IATA_code = "HBA"),
  "\n"
)

# Debug section -----------------------------------------------------------

#lubridate::ymd_hms("2018-02-17T01:05:11Z")
