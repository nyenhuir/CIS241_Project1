#!/usr/bin/env bash

myip=$(curl 'https://api.ipify.org?format=json' | cut -d: -f 2 | tr -d /} | tr -d '"')
mylatitude=$(curl https://ipvigilante.com/$myip | jq '.data.latitude' | tr -d '"')
mylongitude=$(curl https://ipvigilante.com/$myip | jq '.data.longitude' | tr -d '"')
forecasturl=$(curl -L https://api.weather.gov/points/$mylatitude,$mylongitude | jq '.properties.forecast' | tr -d '"')
firstperiod=$(curl -L $forecasturl | jq '.properties.periods[0].name' | tr -d '"')
detailedForecast=$(curl -L $forecasturl | jq '.properties.periods[0].detailedForecast' | tr -d '"')
echo $firstperiod"'s Forecast for ("$mylatitude","$mylongitude"):" $detailedForecast

users
groups
id
