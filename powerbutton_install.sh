 
#!/bin/bash
# Colors: \e[36m=Cyan M ; \e[92m=Light green ; \e[91m=Light red ; \e[93m=Light yellow ; \e[31m=green ; \e[0m=Default ; \e[33m=Yellow ; \e[31m=Red

#branch="development"
version="1.0.4 - 20211220"
repo="https://github.com/PM84/raspberry_pi_power_on_off.git"
branch="main"

nocolor='\e[0m'
red="\e[1;91m"
cyan="\e[1;36m"
yellow="\e[1;93m"
green="\e[1;92m"
installPath="/home/pi/raspberry_pi_power_on_off"
insttype=""

clear
echo -e "///////////////////////////////////////////////////////////////////////////////////////";
echo -e "///${cyan}       ____                             _             _    _                     ${nocolor}///";
echo -e "///${cyan}      |  _ \ _____        __ ___  _ __ | |__   _   _ | |_ | |_  ___  _ __        ${nocolor}///";
echo -e "///${cyan}      | |_) / _ \  \  ^  / // _ \| '__|| '_ \ | | | || __|| __|/ _ \| '_  \      ${nocolor}///";
echo -e "///${cyan}      |  __/ (_) |\ \/ \/ /   __/| |   | |_) || |_| || |_ | |_  (_) | | | |      ${nocolor}///";
echo -e "///${cyan}      |_|   \___/  \_/ \_/  \___||_|   |_.__/  \___/  \__| \__|\___/|_| |_|      ${nocolor}///";
echo -e "///${cyan}        __              ____  ____  _                                            ${nocolor}///";
echo -e "///${cyan}       / _| ___  _ __  |  _ \|  _ \(_)                                           ${nocolor}///";
echo -e "///${cyan}      | |_ / _ \| '__| | |_) | |_) | |                                           ${nocolor}///";
echo -e "///${cyan}      |  _| (_) | |    |    /|  __/| |                                           ${nocolor}///";
echo -e "///${cyan}      |_|  \___/|_|    |_|\_\|_|   |_|                                           ${nocolor}///";
echo -e "///${cyan}                                                                                 ${nocolor}///";
echo -e "///${green}                            developed by Peter Mayer                            ${nocolor}///";                                                                    
echo -e "///${cyan}                                                                                 ${nocolor}///";
echo -e "///////////////////////////////////////////////////////////////////////////////////////"
echo -e "///                                                                                 ///"
echo -e -n "///${cyan}      Version:  ${version}${nocolor}";

lineLen=65
i=0
let lLen="$lineLen"-"${#version}"
while [ "$i" -lt "$lLen" ]
do
	let i+=1
	echo -n -e " "
done
echo -e "///"

echo -e "///${cyan}      Github:   https://github.com/PM84/raspberry_pi_power_on_off.git         ${nocolor}///"
echo -e "///                                                                                 ///"
echo -e "///////////////////////////////////////////////////////////////////////////////////////"
echo -e ""
echo -e "Do you want to install or remove the Power Button for Raspberry Pi?"
echo -e " "
options=("Install" "Remove" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install")
		    insttype="i"
            break
            ;;

        "Remove")
		    insttype="r"
            break
            ;;

        "Quit")
            exit
            ;;
        *) echo -e "invalid option $REPLY";;
    esac
done

clear

echo -e "///////////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}   Remove Listener:                                                  ${nocolor}///"
echo -e "///////////////////////////////////////////////////////////////////////////"
echo -e ""
echo -e -n "   --> Remove Listener:            "
sudo /etc/init.d/shutdownlistener.sh stop
sudo rm /usr/local/bin/shutdownlistener.py
sudo rm /etc/init.d/shutdownlistener.sh
echo -e "${green}done${nocolor}"
echo -e -n "   --> Delete Repository:         "
sudo rm -R ${installPath} > /dev/null 2>&1
echo -e "${green}done${nocolor}"
echo -e ""

if [ "$insttype" = "i" ]
then
    read -n 1 -s -r -p "Listener removed. Press any key to continue"
else
	echo -e "${green}Listener successfully removed...${nocolor}"
    echo -e ""
	exit
fi

clear

cd
echo -e "////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}   Check/Install Prerequirements:                             ${nocolor}///"
echo -e "////////////////////////////////////////////////////////////////////"
echo -e " "
echo -e "Starting installation-process, pleae wait, some"
echo -e "installation steps take some time..."
echo -e ""
echo -e -n "   --> Update Sources:          "
sudo apt -qq update > /dev/null 2>&1
echo -e "${green}done${nocolor}"
echo -e ""
echo -e "Install packages..."

lineLen=24
packages=(git python3) 
for p in ${packages[@]}; do
	i=0
	echo -n -e "   --> $p:"
    let lLen="$lineLen"-"${#p}"
    while [ "$i" -lt "$lLen" ]
    do
		let i+=1
		echo -n -e " "
	done
    installer=`sudo dpkg -s ${p}  2>&1 | grep Status | grep installed`
    if [ "$installer" = "" ]
    then
		installer=`sudo apt -qq -y install ${p} > /dev/null 2>&1`
		installer=`sudo dpkg -s ${p} 2>&1 | grep Status | grep installed`
		if [ "$installer" = "" ]
		then
			echo -e "${red}failed${nocolor}"
		else
			echo -e "${green}done${nocolor}"
		fi
	else
		echo -e "${green}already installed${nocolor}"
	fi
done

# lumaPackages=()
# for p in ${lumaPackages[@]}; do
# 	i=0
# 	let lLen="$lineLen"-"${#p}"
# 	echo -n -e "   --> $p:"
# 	while [ "$i" -lt "$lLen" ]
# 	do
# 		let i+=1
# 		echo -n -e " "
# 	done
# 	pipInstalled=`sudo pip3 list | grep ${p}`
# 	if [ "$pipInstalled" = "" ]
# 	then
# 		sudo pip3 install ${p}  > /dev/null 2>&1
# 		pipInstalled=`sudo pip3 list | grep ${p}`
# 		if [ "$pipInstalled" = "" ]
# 		then
# 			echo -e "${red}failed${nocolor}"
# 		else
# 			echo -e "${green}done${nocolor}"
# 		fi
# 	else
# 		echo -e "${green}already installed${nocolor}"
# 	fi
# done
echo -e ""
read -n 1 -s -r -p "Press any key to continue"

gpioready=0
while [ ${gpioready} = 0 ]; do
	clear
	echo -e "///////////////////////////////////////////////////////////////////////////"
	echo -e "///${cyan}   Set GPIO settings:                                                ${nocolor}///"
	echo -e "///////////////////////////////////////////////////////////////////////////"
	echo -e ""
	echo -e "${red}Please notice:${nocolor} This step asks for the settings of the GPIOs"
	echo -e "of your Raspberry Pi, not the physical PIN!!!"
	echo -e ""
	echo -e "Adjust these values to your needs:"
	echo -e ""
	read -rp "  ---> Type GPIO Pin listen to:  " sdgpio
	echo -e ""
	echo -e ""
	echo -e "The entered values are not checked for correctness!"
	echo -e ""
	echo -e "Check your GPIO-Settings:"
	echo -e "-----------------------------------------------------"
	echo -e "GPIO Shutdown:      ${green}${sdgpio}${nocolor}"
	echo -e ""
	options=("GPIO settings are OK" "Let me adjust the settings again" "Quit")

	select opt in "${options[@]}"
	do
		case $opt in
			"GPIO settings are OK")
			    sudo echo "SD_GPIO = ${sdgpio}" > ${installPath}/config.py
				gpioready=1
				break
				;;

			"Let me adjust the settings again")
				gpioready=0
				break
				;;

			"Quit")
				exit
				;;
			*) echo -e "invalid option $REPLY";;
		esac
	done

done

clear
echo -e "///////////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}   Installing Shutdownlistener:                                       ${nocolor}///"
echo -e "///////////////////////////////////////////////////////////////////////////"
echo -e ""
echo -e "Repository:    ${green}${repo}${nocolor}"
echo -e "Branch:        ${green}${branch}${nocolor}"
echo -e "Install Path:  ${green}${installPath}${nocolor}"

echo -e ""
echo -e ""
echo -e "   Cloning Repository:"
echo -e "   --------------------------------------------------"

git clone ${repo} --branch ${branch} ${installPath} > /dev/null 2>&1
echo -e "${green}done${nocolor}"

echo -e ""
echo -e ""
echo -e "   Installing Listener:"
echo -e "   --------------------------------------------------"

set -e

cd "$(dirname "$0")/.."

echo "=> Installing shutdown listener...\n"
sudo cp ${installPath}/shutdownlistener.py /usr/local/bin/
sudo chmod +x /usr/local/bin/shutdownlistener.py

echo "=> Starting shutdown listener...\n"
sudo cp ${installPath}/shutdownlistener.sh /etc/init.d/
sudo chmod +x /etc/init.d/shutdownlistener.sh

sudo update-rc.d shutdownlistener.sh defaults
sudo /etc/init.d/shutdownlistener.sh start

echo -e "Shutdown listener installed."
echo " => ${green}done${nocolor}"
echo -e ""
echo " => ${green}done${nocolor}"
echo -e ""
echo -e ""
echo -e "${green}Installation finished${nocolor}"
echo -e ""