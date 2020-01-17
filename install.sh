#!/bin/bash

export PWD_START=$(pwd)

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

########################## First Dependances ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mFirst Dependences\e[92m                           \n--------------------------------------------------------------\e[0m"
installRequirements first_requirements.txt


nodes=$(xmlstarlet sel -T -t -m "//root" -m '*' -v "name()" -n tools.xml)
for node in $nodes; do
	mkdir /opt/$(echo $node | tr '[:upper:]' '[:lower:]') 2>/dev/null
  tools=$(xmlstarlet sel -T -t -m "//$node" -m '*' -v "name()" -n tools.xml)
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

clear
mv /opt/Teeth /opt/osint/ 2>/dev/null

########################## Futur Dependances ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mFutur Dependences\e[92m                           \n--------------------------------------------------------------\e[0m"
installRequirements futur_requirements.txt

for node in $nodes; do
	var=choices_$node[@]
	var2=choices_$node
	eval 'nEntries=${#'$var2'[@]}'
	for choice in ${!var}; do
		int=$((3*($choice-1)))
		arrayRef=tab_${node}[1+$int]
		echo -e "\e[92m--------------------------------------------------------------\n                         \e[0m"${!arrayRef}"\e[92m                           \n--------------------------------------------------------------\e[0m"
		eval $(cat tools.xml | xmlstarlet sel -T -t -m "//$node" -m "*[$choice]" -v '*')
	done
	if [ $nEntries != 0 ] 
	then 
		if [ "$node" == "Firefox" ]
		then
			########################## Firefox extensions ##########################
			firefox *.xpi
			rm *.xpi
			pfolder=$(find ~/.mozilla/firefox/ -maxdepth 1 -type d -name '*.proxy' -print -quit);
			dfolder=$(find ~/.mozilla/firefox/ -maxdepth 1 -type d -name '*.default' -print -quit);
			cp -r $dfolder/extensions $pfolder/extensions
			cp $dfolder/extensions.json $pfolder/extensions.json
		fi
	fi
done

find /opt -type d -empty -delete

echo "Installation terminated."
exit 0;

