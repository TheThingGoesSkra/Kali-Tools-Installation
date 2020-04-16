#!/bin/bash

# Author: TheThingGoesSkra

export PWD_START=$(pwd)
export VERSION=$(uname -v | egrep -o "\([^.*-]+" | cut -c2-)

checkPackageIsInstalled() {
	if [[ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]]
		then echo "no"
		else echo "yes"
	fi
}

installRequirements() {
	for pack in `cat ./$1`
	do
		if [[ $(checkPackageIsInstalled $pack) = "no" ]]
		then
			echo "Y" | apt-get install $pack
		else
			echo "$pack is installed well."
		fi
	done
}


#-Start----------------------------------------------------------------#
##### Check if we are running as root - else this script will fail (Hard!)
if [[ "${EUID}" -ne 0 ]]; then
  echo -e ' '${RED}'[!]'${RESET}" This script must be ${RED}run as root${RESET}" 1>&2
  echo -e ' '${RED}'[!]'${RESET}" Quitting..." 1>&2
  exit 1
else
  echo -e " ${BLUE}[*]${RESET} ${BOLD}Post-installation script for Kali Linux.${RESET}"
fi

if [[ "$VERSION" == "2020" ]]; then
	export FILE="tools_2020.xml"
	mkdir /opt
elif [[ "$VERSION" == "2019" ]]; then
	export FILE="tools_2019.xml"
fi	

chmod -R root:root /opt

########################## First Dependances ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mFirst Dependences\e[92m                           \n--------------------------------------------------------------\e[0m"

# Fix repositories
#mv /etc/apt/sources.list /etc/apt/sources.list.old
#cat /etc/apt/sources.list.old | head -n 14 > /etc/apt/sources.list
#printf '\ndeb http://http.kali.org/kali kali-rolling main non-free contrib' >> /etc/apt/sources.list

apt update
installRequirements first_requirements.txt


nodes=$(xmlstarlet sel -T -t -m "//root" -m '*' -v "name()" -n "$FILE")
for node in $nodes; do
	mkdir /opt/$(echo $node | tr '[:upper:]' '[:lower:]') 2>/dev/null
  tools=$(xmlstarlet sel -T -t -m "//$node" -m '*' -v "name()" -n "$FILE")
	eval "tab_$node=()"
	int=1
	for tool in $tools; do
		eval "tab_$node+=($int $tool off)"
		let "int+=1"
	done
done

for node in $nodes; do
	arrayRef=tab_${node}[@]
	var=tab_${node}
	eval 'nEntries=${#'${var}'[@]}'
	if [ $nEntries != 0 ]
	then
		declare -a choices_$node="($(dialog --separate-output --checklist \"$node:\" 22 76 16 ${!arrayRef} 2>&1 >/dev/tty))"
	fi
done

#clear
mv /opt/Teeth /opt/osint/ 2>/dev/null

########################## Futur Dependances ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mFutur Dependences\e[92m                           \n--------------------------------------------------------------\e[0m"
installRequirements futur_requirements.txt
wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py
python get-pip.py

for node in $nodes; do
	var=choices_$node[@]
	var2=choices_$node
	eval 'nEntries=${#'$var2'[@]}'
	for choice in ${!var}; do
		int=$((3*($choice-1)))
		arrayRef=tab_${node}[1+$int]
		echo -e "\e[92m--------------------------------------------------------------\n                         \e[0m"${!arrayRef}"\e[92m                           \n--------------------------------------------------------------\e[0m"
		eval $(cat "$FILE" | xmlstarlet sel -T -t -m "//$node" -m "*[$choice]" -v '*')
	done
	if [ $nEntries != 0 ] 
	then 
		if [ "$node" == "Firefox" ]
		then
			########################## Firefox extensions ##########################
			su -c "firefox *.xpi" $SUDO_USER
			rm *.xpi
			pfolder=$(find /home/$SUDO_USER/.mozilla/firefox/ -maxdepth 1 -type d -name '*.roxy' -print -quit);
			dfolder=$(find /home/$SUDO_USER/.mozilla/firefox/ -maxdepth 1 -type d -name '*.default-release' -print -quit);
			cp -r $dfolder/extensions $pfolder
			cp $dfolder/extensions.json $pfolder/extensions.json
			chown -R $SUDO_USER:$SUDO_USER $pfolder
		fi
	fi
done

find /opt -type d -empty -delete
chown -R $SUDO_USER:$SUDO_USER /opt
echo "Installation terminated."
exit 0;
