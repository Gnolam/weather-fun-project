debug_message_l2("[setup] toy-model coefficients")

# Take Sydney coord as a reference
# lat -33.865143
# Calculate difference vs. Sydney
# Positive numver means closer to Equator and thus warmer
# We ignore here presence of the deserts etc.
# for each 1 degree in latitude we assume the temperature changes by .5 degree
# Thus Darwin is ~10 warmer vs Sydney
latitude_modifier <- 1 # C/degree of latitude (valid for South hemisphere)


# Altitude - temperature relationship
# Calculate the temperature at the altitude of your choice in the troposphere.
# Temperatures in the troposphere drop an average of 6.5 degrees C per kilometer
# Source: https://sciencing.com/tutorial-calculate-altitude-temperature-8788701.html
altitude_modifier <- -6.5 # C/km


# randomisation coefficients
stochastics <- list(
  annual = list(
    shift = 5,  # +/- 5 degrees
    scale = .05 # +/- 5%
  ),
  daily = list(
    scale = .2 # +/- 10%
  )
)


# Decay of pressure with altitude
pressure_altitude_decrease = -0.05