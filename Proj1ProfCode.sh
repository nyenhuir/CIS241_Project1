#!/usr/bin/env bash

${DIALOG_OK=0}
${DIALOG_CANCEL=1}

dialog_box(){
	dialog--clear--msgbox "$1" 0 0 2>&1 1>&3
}

list_maker(){
	output=""
	for i in $1; do
		output="$output\n\t-$i"
	done
	echo $output
}

user_menu(){
	while true;do
		choice=$(dialog \
			--backtitle "User Information" \
			--clear \
			--menu "You are logged in as ${USER} with id=$(id -u)." 0 0 3 \
			"1" "Primary group" \
			"2" "List groups numerically" \
			"3" "List group names" \
			2>&1 1>&3)
		return_value=$?
		case $return_value in
			$DIALOG_OK)
				case $choice in
					1)
						dialog_box "Your primary group is $(id-g)";;
				esac;;
			$DIALOG_CANCEL)
				return;;
		esac
	done
}

weather_menu(){
	while true;do
		echo "0" | dialog --gauge "Retrieving Data" 10 70 0
		myip=$(curl -s 'https://api.ipify.org?format=json' | cut -d: -f 2 | tr -d /} | tr -d '"')
		echo "25" | dialog --gauge "Retrieving Data" 10 70 0
		ipdata=$(curl -s https://ipvigilante.com/$myip)
		echo "50" | dialog --gauge "Retrieving Data" 10 70 0

		mylongitude=$(echo $ipdata | jq '.data.longitude' | tr -d '"')
		mylatitude=$(echo $ipdata | jq '.data.latitude' | tr -d '"')
		forecasturl=$(curl -Ls https://api.weather.gov/points/$mylatitude,$mylongitude | jq '.properties.forecast' | tr -d '"')
		echo "75" | dialog --gauge "Retrieving Data" 10 70 0

		forecast=$(curl -Ls $forecasturl)
		echo "100" | dialog --gauge "Retrieving Data" 10 70 0

		firstperiod=$(echo $forecast | jq '.properties.periods[0].name' | tr -d '"')
		echo done: $firstperiod done2
		detailedForecast=$(echo $forecast | jq '.properties.periods[0].detailedForecast' | tr -d '"')
		echo $firstperiod"'s Forecast for ("$mylatitude","$mylongitude"):" $detailedForecast


		choice=$(dialog \
			--backtitle "Weather Information" \
			--clear \
			--menu "You are logged in as ${USER} with id=$(id -u)." 0 0 3 \
			"1" "Primary group" \
			"2" "List groups numerically" \
			"3" "List group names" \
			2>&1 1>&3)
		return_value=$?
		case $return_value in
			$DIALOG_OK)
				case $choice in
					1)
						dialog_box "Your primary group is $(id-g)";;
				esac;;
			$DIALOG_CANCEL)
				return;;
		esac
	done
}

while true; do
	exec 3>&1
	choice=$(dialog \
		--backtitle "Information Center- $(date)" \
		--clear \
		--menu "Choose from the following:" 0 0 4 \
		"1" "User Information" \
		"2" "System Information" \
		"3" "Weather Information" \
		2>&1 1>&3)
	return_value=$?
	case $return_value in
		$DIALOG_OK)
			case $choice in
				1)
					user_menu;;
				2)
					system_menu;;
				3)
					weather_menu;;
			esac;;
		$DIALOG_CANCEL)
			exec 3>&-
			echo "Thanks!";
			exit;;
	esac
done
