#!/usr/bin/env bash

myip=$(curl 'https://api.ipify.org?format=json' | cut -d: -f 2 | tr -d /} | tr -d '"')
ipdata=$(curl https://ipvigilante.com/$myip)
mylongitude=$(echo $ipdata | jq '.data.longitude' | tr -d '"')
mylatitude=$(echo $ipdata | jq '.data.latitude' | tr -d '"')
forecasturl=$(curl -L https://api.weather.gov/points/$mylatitude,$mylongitude | jq '.properties.forecast' | tr -d '"')
forecast=$(curl -L $forecasturl)
firstperiod=$(echo $forecast | jq '.properties.periods[0].name' | tr -d '"')
echo done: $firstperiod done2
detailedForecast=$(echo $forecast | jq '.properties.periods[0].detailedForecast' | tr -d '"')
echo $firstperiod"'s Forecast for ("$mylatitude","$mylongitude"):" $detailedForecast

users
groups
id
