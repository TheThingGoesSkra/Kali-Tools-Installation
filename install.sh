#!/bin/bash

export PWD_START=$(pwd)

########################## Dependances ##########################
apt-get install dialog
apt-get install xmlstarlet

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

########################## Dependances ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mDependences\e[92m                           \n--------------------------------------------------------------\e[0m"
echo "Y" | apt-get install npm
echo "Y" |apt-get install git
apt-get install golang
apt-get install rpcbind
apt-get install libnss3-tools;

########################## Bash configuration ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mBash configuration\e[92m                           \n--------------------------------------------------------------\e[0m"
cd ~;
git init;
git remote add origin https://github.com/TheThingGoesSkra/Bash_config.git;
rm .bashrc;
git pull origin master;
cd $PWD_START;

########################## System optimisation ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mSystem optimisation\e[92m                           \n--------------------------------------------------------------\e[0m"
echo "vm.swappiness=10" >> /etc/sysctl.conf
sed -i -e 's/\(GRUB_TIMEOUT=\).*/\10/' /etc/default/grub

for node in $nodes; do
	var=choices_$node[@]
	for choice in ${!var}; do
		int=$((3*($choice-1)))
		arrayRef=tab_${node}[1+$int]
		echo -e "\e[92m--------------------------------------------------------------\n                         \e[0m"${!arrayRef}"\e[92m                           \n--------------------------------------------------------------\e[0m"
		eval $(cat tools.xml | xmlstarlet sel -T -t -m "//$node" -m "*[$choice]" -v '*')
	done
done

########################## Burp configuration ##########################
echo -e "\e[92m--------------------------------------------------------------\n                         \e[0mBurp configuration\e[92m                           \n--------------------------------------------------------------\e[0m"
echo "y" | java -Djava.awt.headless=true -Xmx1g -jar /bin/burpsuite &
export APP_PID=$!;
sleep 25;
wget -e use_proxy=yes -e http_proxy=http://127.0.0.1:8080 http://burp/cert -O cacert.der;
sleep 5;
sudo kill -SIGTERM $APP_PID;
firefox --no-remote -CreateProfile proxy;
folder=$(find ~/.mozilla/firefox/ -maxdepth 1 -type d -name '*.proxy' -print -quit);
certutil -A -n Burp -t "CT,c,c" -d "${folder}" -i cacert.der;
cat prefs.js.old > "$folder/prefs.js";
sudo openssl x509 -in cacert.der -inform DER -out burp.crt;
sudo cp burp.crt /usr/local/share/ca-certificates/burp.crt;
update-ca-certificates;
