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
