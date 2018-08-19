this document serves as a 'notepad' for the next actions
'Trello' is better but...

## 'Sprint #1': Exploration
- [x] Test if poly approximates annual weather
- [x] Create fit function for annual temperature
- [x] Create fit function for intra-day temperature

- [~] Check where to download reliable data for a signle weather station
- [ ] Prepare the list of weather stations
- [x] Come up with the idea how to approximate daily temperature


## 'Sprint #2': Annual temperature properties of the stations
- [ ] Create project setup: list of stations and all 'const' properties
- [ ] Download .csv files from BOM with properties of each station
- [ ] Approximate + check the RMSE of the approximation
- [ ] Save fit coefficients objects as a part of the setup

## 'Sprint #3': Intra-day + within-year approximation for temperature
- [ ] Take 4 different daily temps (from different latitudes) and approximate them
- [ ] Make test runs/predictions for temperature for station X, datetime Y.
- [ ] Add stochastic functionality for temperature

## 'Sprint #4': Add Toy-model features
- [ ] Implement Pressure, Humidity and Condition calculation based in temperature, (x, y, h) properties of the 
- [ ] Add stochastic functionality for derived properties
- [ ] Create the generic function with params similar to CLI description
- [ ] Add MA smoothing (* if time allows)

## 'Sprint #5': Add CLI params definition
- [ ] Make generic function which could be used for both Shiny and CLI
- [ ] Apply one of the standard libraries for CLI control over the simulation function

## 'Sprint #6': Testing and acceptance
- [ ] Create documentation and tests of how to run / check / accept results
- [ ] Create documentation on the implemented features
- [ ] Create documentation on the unfinished features


## Potential 'Sacrafice' list
The list below serves as a list of features which are 'the must' for MVP.
The rest can be 'sacraficed' in case of time shortage
- [ ] Stochastic features
- [ ] RShiny interface or CLI. Just one of them
- [ ] All stations will be the 'shift' function of one curve