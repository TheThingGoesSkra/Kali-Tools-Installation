#!/bin/bash

export PWD_START=$(pwd)

########################## Dependances ##########################
echo "Y" | apt-get install npm
echo "Y" |apt-get install git
apt-get install rpcbind
apt-get install dialog

nodes=$(xmlstarlet sel -T -t -m "//root" -m '*' -v "name()" -n tools.xml)
for node in $nodes; do
	mkdir /opt/$(echo $node | tr '[:upper:]' '[:lower:]') 2>/dev/null
  tools=$(xmlstarlet sel -T -t -m "//$node" -m '*' -v "name()" -n tools.xml)
	eval "tab_$node=()"
	int=1
	for tool in $tools; do
		eval "tab_$node+=($int $tool on)"
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

for node in $nodes; do
	var=choices_$node[@]
	for choice in ${!var}; do
		int=$((3*($choice-1)))
		arrayRef=tab_${node}[1+$int]
		echo -e "\e[92m--------------------------------------------------------------\n                         \e[0m"${!arrayRef}"\e[92m                           \n--------------------------------------------------------------\e[0m"
		eval $(xmlstarlet sel -T -t -m "//$node" -m "*[$choice]" -v '*' -n tools.xml)
	done
done
