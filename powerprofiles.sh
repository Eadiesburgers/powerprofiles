#!/usr/bin/env bash

#Author: Rob Lawton
#Version: 3.0
#Date: 16-Feb-2026
#Usage: Set/see power profiles
#Dependencies: Tuned

#set constants
set -eo pipefail
RED='\033[0;31m';
GREEN='\033[0;32m';


#functions
function help
	{
	#used numbers, no case sense
	echo -e "$GREEN""------------------------------------------------------------------------"
	echo -e "$GREEN""|Supply an option:                                                     |"
	echo -e "$GREEN""|                                                                      |"
	echo -e "$GREEN""|    \"1\" - See current mode set.                                       |"
	echo -e "$GREEN""|    \"2\" - Set performance mode.                                       |"
	echo -e "$GREEN""|    \"3\" - Set balanced mode.                                          |"
	echo -e "$GREEN""|    \"4\" - Set power save mode.                                        |"
	echo -e "$GREEN""|    \"5\" - See current CPU load.                                       |"
	echo -e "$GREEN""|----------------------------------------------------------------------|"
	echo -e "$GREEN""|    \"0\" - exit.                                                       |"
	echo -e "$GREEN""|----------------------------------------------------------------------|"
	echo -e "$GREEN""|                                                                      |"
	echo -e "$GREEN""|Note - for full list of power options available use \"tuned-adm list\"  |"
	echo -e "$GREEN""------------------------------------------------------------------------"
	}

function doit
	{
	#command=$1
	#general msg=$2
	#error msg=$3
	clear
	trap 'echo -e "$RED""$3"; exit 1;' ERR
	echo -e "$GREEN""$2"
	command $1
	read -p "Press any key to continue."
	clear
	}

#begin
spinner=('/' '-' '\' '|')
spin_index=0

clear
help
while true; do
    read -p ">_" optionin
    case "$optionin" in
        0|1|2|3|4|5)
			case "$optionin" in
				    0)
						break
				        ;;
				    1)
				    	doit "tuned-adm active" "" "Halting, error detected! You have tuned installed?"
				    	help
				        ;;
				    2)
						doit "tuned-adm profile throughput-performance" "Setting performance mode..." "Halting, error detected! You have tuned installed and all profiles?"
				        doit "tuned-adm active" "Confirming..." "Halting, error detected! You have tuned installed?"
				    	help
						;;  
				    3)
						doit "tuned-adm profile balanced" "Setting balanced mode..." "Halting, error detected! You have tuned installed and all profiles?"
				        doit "tuned-adm active" "Confirming..." "Halting, error detected! You have tuned installed?"
				    	help
				        ;;  
				    4)
				        doit "tuned-adm profile powersave" "Set power save mode..." "Halting, error detected! You have tuned installed and all profiles?"
				        doit "tuned-adm active" "Confirming..." "Halting, error detected! You have tuned installed?"
				    	help
				        ;;  
				    5)
				    	while true; do
	    					clear
	    					spin_index=$(( (spin_index + 1) % 4 ))
	    					echo -e "$GREEN""---------------"
	    					echo -e "$GREEN""${spinner[$spin_index]}""  CPU Speed  ""${spinner[$spin_index]}"
	    				    echo -e "$GREEN""--------------------------"
	    					grep -i "cpu MHz" /proc/cpuinfo
	    					echo -e "$GREEN""--------------------------"
	    					echo
	    					echo -e "$GREEN""(Press any key to stop and return back to main menu)."
							sleep 0.2
	        				read -t 0.2 -n 1 key && break
						done
				        clear
				        help
				        ;;  

				    *)
				        help
				        ;;  
				esac
            ;;
        *)
        	clear
            help
            ;;
    esac
done

