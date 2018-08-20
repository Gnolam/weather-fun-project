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
  "csv_header": true,
  "from_date_time": "2018-02-17 01:05:11",
  "number_of_steps": 10,
  "step_size": "days"
}
```
In the example above the file `10 days exampe.csv` will be created in tho `io/output` folder and it will have 11 days of weather simulations in tolal
per EACH of the station defined in the `io/input/weather_stations.csv` database.

`from_date_time` must be in date-time format.

`step_size` can be in one of the following types: "days", "mins", "secs", "hours", "months", "years"


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

Conditions are considered random event. On average 5 rainy days a month. Separately and independently for each station
For the sake of coding time let's have it random for each point generated with probablity of rain/snow of 10%


## Humidity

`humidity` ~ change in humidity is defined as proportional to negative change in temperature temperature

Meaing the lower the temperature the higher is humidity and other way round

Also humidity is higher if it is raining

__(!)__ Not sure how humidity should behave under negative temperature


## Atmosphere pressure
Atmosphere pressure was left constant for simplicity with tiny random changes and drop in pressure due to rains and small decrease with elevation

```
atm_pressure <- 
    1100 +                                     # base value
    runif(n = 1, min = -20,max = 20) +         # boring without random
    ifelse(is_clear_weather, 0, -100) +        # if rain then less
    coord$alt * cfg$pressure_altitude_decrease # should be dropping with height

```



## Key features of the project (left for future)

- Input means
- CLI (command line interface)
- JSON format would be way easier...
- RShiny
- RServ -> http API endpoint?
  
  - Required input parameters
- `--datetime:` or `--dt:` is a starting date time. Time should be "TMD HMS" format
    _a  POSIXct date-time objects_
- `--periods` or `--num:` is a number of time points to genereate
- `--incremental` or `--inc:` is a 'size of incremental step' between periods. 

### Optional input parameters
- `--stochastic:` or `--st:`. 'ON' by default. 
- 'OFF' - values are determenistic and infered from real world data.
- 'ON' (by default). Permission for a simulator to add random fluctuations for daily parameters. If 'ON' the result will be slightly different each time the data are simulated
- 'LOTS'. Adding extreme events. Heatwaves and long rains



### Input params considerations
- _(!)_ Datetime should be specified in UTC time zone
- Option for date (instead of datetime) is not considered due to potential confusion with UTC timezone
- Datetime should be in between year 2000 and 3000
- Number of periods should be in between 1 and 10,000
- Incremental option can be in several forms
- `sec`: seconds
- `min`: minutes
- `hour`: hours
- `day`: days
- `month`: months
- `year`: years


## Output
- Into a file for CLI  
- Through 'Download' functionality for RShiny
- No multiple periods assumed at the moment for the sake of time


## Working notes
Year part is ignored in the simulation. Only part of the year and part of the day

We consider altitude to be within `troposphere` - before 11km. Otherwise the relationship alt-temp is not monotonic
"Calculate the temperature at the altitude of your choice in the troposphere. Temperatures in the troposphere drop an average of 6.5 degrees C per kilometer" ~  https://sciencing.com/tutorial-calculate-altitude-temperature-8788701.html



