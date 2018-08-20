## Welcome to The Weather project
This document serves as a Wiki and a master plan for the project


## How to run the project

### How to execute the script
Under Linux machine the following should execute the project
```
Rscript root.R
```

Under Windows... well it would be easier to run it from RStudio.


### How to specify the task

The tasks are the JSON objects stored in `io/task` folder.
Hers is the example of the task file:
```JSON
{
  "file_name": "10 days exampe.csv",
  "csv_header": [true],
  "from_date_time": "2018-02-17 01:05:11",
  "number_of_steps": 10,
  "step_size": "days"
}
```
In the example above the file `10 days exampe.csv` will be created in tho `io/output` folder and it will have 11 days of weather simulations in tolal
per EACH of the station defined in the `io/input/weather_stations.csv` database.

`from_date_time` must be in date-time format.

`step_size` can be in one of the following types: "days", "mins", "secs", "hours", "months", "years"

`csv_header` regulates if we want to add the header to an output file.
Please not that many systems __require__ header-less files in order to 
perform at a high speed.

Example of the several lines of the output file 
```
CBR|-35.31,149.2,575|2018-02-17T01:05:11Z|Clear|+18.9|1070.1|77.0
CBR|-35.31,149.2,575|2018-02-18T01:05:11Z|Clear|+18.9|1054.4|77.0
CBR|-35.31,149.2,575|2018-02-19T01:05:11Z|Clear|+18.8|1072.1|77.0
CBR|-35.31,149.2,575|2018-02-20T01:05:11Z|Clear|+18.7|1057.4|77.0
CBR|-35.31,149.2,575|2018-02-21T01:05:11Z|Rain|+18.7|976.2|97.0
CBR|-35.31,149.2,575|2018-02-22T01:05:11Z|Clear|+18.6|1085.9|77.0
CBR|-35.31,149.2,575|2018-02-23T01:05:11Z|Clear|+18.5|1052.7|77.0
CBR|-35.31,149.2,575|2018-02-24T01:05:11Z|Rain|+18.4|980.6|97.0
CBR|-35.31,149.2,575|2018-02-25T01:05:11Z|Clear|+18.4|1054.3|77.0
CBR|-35.31,149.2,575|2018-02-26T01:05:11Z|Rain|+18.3|967.0|97.0
CBR|-35.31,149.2,575|2018-02-27T01:05:11Z|Clear|+18.2|1058.8|77.0
SYD|-33.95,151.18,9|2018-02-17T01:05:11Z|Clear|+23.4|1103.7|77.0
SYD|-33.95,151.18,9|2018-02-18T01:05:11Z|Rain|+23.4|1007.0|97.0
SYD|-33.95,151.18,9|2018-02-19T01:05:11Z|Clear|+23.3|1118.3|77.0
```


* * *


# Toy model
- [x]  Outline key 'toy-model' assumptions
coordinate tripple (lat, lon, alt) is a given constant for each station

## Temperature
For the sake of simplicity is defined as
`temperature` = f(`latitude`, `altitude`, `stochastic actors` , `datetime` )
_Note:_ year is ignored, only within-year and within-day fluctuations are taken into account


```R
  final_temperature_prediction <-
    temperature_annual * annual_scale + annual_shift
    temperature_daily  * daily_scale +
    temperature_latitude +
    temperature_altitude
```

where

- `temperature_annual` - deterministic function. Uses reference annual temperature curve
- `annual_scale` + `annual_shift` are the stochastic factors. E.g. +/- 5 degrees and +/- 10% to the annual curve (defined by the config file)
- `temperature_daily` - similar to annual curve this one define sdaily fluctuations of the temperature
- `daily_scale` - random magnitude factor. Can scale or shrink the daily curve within some % (defined by the config file)
 - `temperature_latitude` for each 1 degree in latitude we assume the temperature changes by .5 degree (defined by the config file)
 - `temperature_altitude` - with the increase of latitude the temperature permanently drops by X degrees (defined by the config file)


## Conditions

Conditions are considered random event. On average 6 rainy days a month. Separately and independently for each station
For the sake of coding time let's have it random for each point generated with probablity. As a drawback it may result in changing rain/clear every sevral seconds if 'secs' interval is selected

```R
  is_clear_weather <- runif(n = 1, min = 0, max = 100) > 25
  conditions_str <- ifelse(
    is_clear_weather,
    "Clear",
    ifelse(
      final_temperature_prediction > 0,
      "Rain",
      "Snow"
    )

```

## Humidity

`humidity` ~ change in humidity is defined as proportional to negative change in temperature temperature

Meaing the lower the temperature the higher is humidity and other way round

Also humidity is higher if it is raining

__(!)__ Not sure how humidity should behave under negative temperature

```R

  is_clear_weather <- runif(n = 1, min = 0, max = 100) > 25
  conditions_str <- ifelse(
    is_clear_weather,
    "Clear",
    ifelse(
      final_temperature_prediction > 0,
      "Rain",
      "Snow"
    )
```



## Atmosphere pressure
Atmosphere pressure was left constant for simplicity with tiny random changes and drop in pressure due to rains and small decrease with elevation

```
atm_pressure <- 
    1100 +                                     # base value
    runif(n = 1, min = -20,max = 20) +         # boring without random
    ifelse(is_clear_weather, 0, -100) +        # if rain then less
    coord$alt * cfg$pressure_altitude_decrease # should be dropping with height

```



## Working notes
Year part is ignored in the simulation. Only part of the year and part of the day

We consider altitude to be within `troposphere` - before 11km. Otherwise the relationship alt-temp is not monotonic
"Calculate the temperature at the altitude of your choice in the troposphere. Temperatures in the troposphere drop an average of 6.5 degrees C per kilometer" ~  https://sciencing.com/tutorial-calculate-altitude-temperature-8788701.html



