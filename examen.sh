#!/bin/bash
echo "Introdueix Nom + El Primer Cognom:"
read nom
clear
VERSIO=$(lsb_release -d | grep "Description" | cut -d ' ' -f2-4)
DATA_IN=$(head -1 /var/log/installer/syslog | cut -c 1-12)
DATA_FI=$(tail -1 /var/log/installer/syslog | cut -c 1-12)
RAM=$(vmstat -s -S M | grep "total memory" | cut -c 1-16)
HDD=$(df -h -t ext4 | awk ‘{pront $2}’ | sort -k 2 | head -1)
echo "[*] Nom Alumne: ${nom}"
echo "[*] La versió de Linux és: $VERSIO"
echo "[*] Inici de la instal·lació: $DATA_IN";
echo "[*] Final de la instal·lació: $DATA_FI";
echo "[*] Característiques (RAM / HDD): $RAM / $HDD"
echo
echo "+---------------------------------------------+"


clear
#Exercici a)
#Exemple amb la ip 192.168.1.251/24
#primer creem xarxa nat amb ipv4 192.168.1.0/24 després en el reenviament de ports posarem
#127.0.0.1 8888 192.168.1.251 80
#despres modificarem l arxiu /etc/network/interfaces
#iface enp0s3 inet static
#address 192.168.1.251/24 gateway 192.168.1.1
#modifiquem arxiu etc/resolv.conf(comentem el que hi ha dintre)
#nameserver 192.168.1.1

White='\033[0;37m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
BBlue='\033[1;34m'
Cyan='\033[0;36m'
Purple='\033[0;35m'
#Comprovacio usuari root
echo -e " ______ _      _____ _____"
echo -e "/ _____| |    |  __ \_   _|"
echo -e "| | ___| |    | |__) || | "
echo -e "| | |_ | |    |  ___/ | |  "
echo -e "| |__| | |____| |    _| |_ "
echo -e "\______|______|_|   |_____|"
echo -e "\n\n"

echo -e "${Purple}Comprovacions preliminars\n"
if [ $(whoami) == "root" ]; then
	echo -e "${Cyan}Ets root, seguirem amb l'instalacio"
	echo "Ets root, seguirem amb l'instalacio" >>/var/logs/registres/install/glpi.log
else
	echo -e "${Yellow}No ets root, resgistret com usuari root i torna a executar el script"
	echo "No ets root, resgistret com usuari root i torna a executar el script" >>/var/logs/registres/install/errors.log
	exit
fi

#Comprovacio conexio a internet
apt-get update >/dev/null 2>&1

if [ $? -eq 0 ]; then

	echo -e "${Cyan}Conexio a internet comprobada"
	echo "Conexio a internet comprobada" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}No tens conexio a internet, conectat i torna a executar el script"
	echo "No tens conexio a internet, conectat i torna a executar el script" >>/var/logs/registres/install/errors.log

fi

echo -e "\n\n${Purple}Instalació LAMP\n"
#Instal.lacio apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' >/dev/null 2>&1 | grep -c "ok installed") -eq 0 ]; then

	echo -e "${Yellow}Apache2 no esta instal.lat, procedim amb la descarga"
	apt-get -y install apache2 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}Apache2 instal.at correctament\n"
		echo "Apache2 instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}Apache2 instal.lat incorrectament\n"
		echo "Apache2 instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}Apache2 ja esta instal.lat, continuem\n"

fi

#Instal.lacio mariadb-server
if [ $(dpkg-query -W -f='${Status}' 'software-properties-common' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Software-properties-common no esta instal.lat, procedim amb la descarga"
	apt-get -y install software-properties-common >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}Software-properties-common instal.at correctament\n"
		echo "Software-properties-common instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}Software-properties-common instal.lat incorrectament"
		echo "Software-properties-common instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}Software-propertes-common ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'dirmngr' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Dirmngr no esta instal.lat, procedim amb la descarga"
	apt-get -y install dirmngr >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}Dirmngr instal.at correctament\n"
		echo "Dirmngr instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}Dirmngr instal.lat incorrectament"
		echo "Dirmngr instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}Dirmngr ja esta instal.lat, continuem\n"

fi

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Purple}Treballant..."

else

	echo -e "${Yellow}Error recv-keys"
	echo "Error recv-keys" >>/var/logs/registres/install/errors.log
	exit
fi

add-apt-repository 'deb [arch=amd64] https://mirror.rackspace.com/mariadb/repo/10.4/debian buster main' >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "Treballant...\n"

else

	echo -e "${Yellow}Error apt-repository"
	echo "Error apt-repository" >>/var/logs/registres/install/errors.log
	exit
fi
apt-get update >/dev/null 2>&1




if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Mariadb-server no esta instal.lat, procedim amb la descarga"
	apt-get -y install mariadb-server >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}Mariadb-server instal.at correctament\n"
		echo "Mariadb-server instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}Mariadb-server instal.lat incorrectament"
		echo "Mariadb-server instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}Mariadb-server ja esta instal.lat, continuem\n"

fi




#Instal.lacio php
if [ $(dpkg-query -W -f='${Status}' 'php' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP no esta instal.lat, procedim amb la descarga"
	apt-get -y install php >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP instal.at correctament\n"
		echo "PHP instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP instal.lat incorrectament"
		echo "PHP instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP ja esta instal.lat, continuem\n"

fi


#Instal.lacio php-mysql
if [ $(dpkg-query -W -f='${Status}' 'php-mysql' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP-mysql no esta instal.lat, procedim amb la descarga"
	apt-get -y install php-mysql >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP-mysql instal.at correctament\n"
		echo "PHP-mysql instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP-mysql instal.lat incorrectament"
		echo "PHP-mysql instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP-mysql ja esta instal.lat, continuem\n"

fi
clear

cd /opt/

echo -e "${Purple}Descarrega i descompresio GLPI\n"
#descarga i descompresio del paquet
wget https://github.com/glpi-project/glpi/releases/download/10.0.7/glpi-10.0.7.tgz >/dev/null 2>&1

if [ $? -eq 0 ]; then

	echo -e "${Cyan}GLPI descarregat correctament\n"
	echo "GLPI descarregat correctament" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error al descarregar GLPI"
	echo "Error al descarregar GLPI" >>/var/logs/registres/install/errors.log
	exit
fi


echo -e "${Purple}Descomprimint paquet descarregat..."
tar zxvf glpi-10.0.7.tgz >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Descompresio correcta\n"
	echo "Descompresio correcta" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error de descompresio"
	echo "Error de descompresio" >>/var/logs/registres/install/errors.log
	exit
fi


echo -e "${Purple}Eliminant fitxer a la carpeta html..."
rm -R /var/www/html/
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Eliminacio correcte\n"
	echo "Eliminacio correcte" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error al eliminar"
	echo "Error al eliminar" >>/var/logs/registres/install/errors.log
	exit
fi

echo -e "${Purple}Movent arxiu a la cartpeta html..."
mv  glpi /var/www/html/
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Moviment correcta\n"
	echo "Moviment correcta" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error al moure"
	echo "Error al moure" >>/var/logs/registres/install/errors.log
	exit
fi

chmod 755 -R /var/www/html/
chown -R www-data:www-data /var/www/

clear

echo -e "${Purple}Instalació php7.4 i activació"
#Instalació paquets php7.4 i activació

if [ $(dpkg-query -W -f='${Status}' 'lsb-release' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}lsb-release no esta instal.lat, procedim amb la descarga"
	apt-get -y install lsb-release >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}lsb-release instal.at correctament\n"
		echo "lsb-release instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}lsb-release instal.lat incorrectament"
		echo "lsb-release instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}lsb-release ja esta instal.lat, continuem\n"

fi


if [ $(dpkg-query -W -f='${Status}' 'apt-transport-https' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}apt-transport-https no esta instal.lat, procedim amb la descarga"
	apt-get -y install apt-transport-https >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}apt-transport-https instal.at correctament\n"
		echo "apt-transport-https instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}apt-transport-https instal.lat incorrectament"
		echo "apt-transport-https instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}apt-transport-https ja esta instal.lat, continuem\n"

fi


if [ $(dpkg-query -W -f='${Status}' 'ca-certificates' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}ca-certificates no esta instal.lat, procedim amb la descarga"
	apt-get -y install ca-certificates >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}ca-certificates instal.at correctament\n"
		echo "ca-certificates instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}ca-certificates instal.lat incorrectament"
		echo "ca-certificates instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}ca-certificates ja esta instal.lat, continuem\n"

fi

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Purple}Treballant..."

else

	echo -e "${Yellow}Error links php"
	echo "Error links php" >>/var/logs/registres/install/errors.log
	exit
fi

echo -e "deb https://packages.sury.org/php/ $( lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

if [ $? -eq 0 ]; then

	echo -e "${Purple}Treballant...\n"

else

	echo -e "${Yellow}Error links echo"
	echo "Error links echo" >>/var/logs/registres/install/errors.log
	exit
fi
apt-get update >/dev/null 2>&1

if [ $(dpkg-query -W -f='${Status}' 'php7.4' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4 no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4 instal.at correctament\n"
		echo "PHP7.4 instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4 instal.lat incorrectament"
		echo "PHP7.4 instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4 ja esta instal.lat, continuem\n"

fi

echo -e "${Purple}Activant php7.4..."

a2dismod php7.3 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Desactiviacio php7.3 correcte\n"
	echo "Desactiviacio php7.3 correcte" >>/var/logs/registres/install/glpi.log
else

	echo  -e "${Yellow}Error al desactivar php7.3"
	echo "Error al desactivar php7.3" >>/var/logs/registres/install/errors.log
	exit
fi

a2enmod php7.4 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Activació php7.4 correcte\n"
	echo "Activació php7.4 correcte" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error al activar php7.4"
	echo "Error al activar php7.4" >>/var/logs/registres/install/errors.log
	exit
fi

#Intalació tots paquets secundaris
if [ $(dpkg-query -W -f='${Status}' 'php7.4-apcu' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-apcu no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-apcu >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-apcu instal.at correctament\n"
		echo "PHP7.4-apcu instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-apcu instal.lat incorrectament"
		echo "PHP7.4-apcu instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-apcu ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-bz2' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-bz2 no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-bz2 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-bz2 instal.at correctament\n"
		echo "PHP7.4-bz2 instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-bz2 instal.lat incorrectament"
		echo "PHP7.4-bz2 instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-bz2 ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-curl' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-curl no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-curl >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-curl instal.at correctament\n"
		echo "PHP7.4-curl instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-curl instal.lat incorrectament"
		echo "PHP7.4-curl instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-curl ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-gd' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-gd no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-gd >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-gd instal.at correctament\n"
		echo "PHP7.4-gd instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-gd instal.lat incorrectament"
		echo "PHP7.4-gd instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-gd ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-intl' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-intl no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-intl >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-intl instal.at correctament\n"
		echo "PHP7.4-intl instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-intl instal.lat incorrectament"
		echo "PHP7.4-intl instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-intl ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-ldap' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-ldap no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-ldap >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-ldap instal.at correctament\n"
		echo "PHP7.4-ldap instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-ldap instal.lat incorrectament"
		echo "PHP7.4-ldap instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-ldap ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-mbstring' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-mbstring no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-mbstring >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-mbstring instal.at correctament\n"
		echo "PHP7.4-mbstring instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-mbstring instal.lat incorrectament"
		echo "PHP7.4-mbstring instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-mbstring ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-xml' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-xml no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-xml >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-xml instal.at correctament\n"
		echo "PHP7.4-xml instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-xml instal.lat incorrectament"
		echo "PHP7.4-xml instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-xml ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-xmlrpc' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-xmlrpc no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-xmlrpc >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-xmlrpc instal.at correctament\n"
		echo "PHP7.4-xmlrpc instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-xmlrpc instal.lat incorrectament"
		echo "PHP7.4-xmlrpc instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-xmlrpc ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-zip' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-zip no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-zip >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-zip instal.at correctament\n"
		echo "PHP7.4-zip instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-zip instal.lat incorrectament"
		echo "PHP7.4-zip instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-zip ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-mysql' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-mysql no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-mysql >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Cyan}PHP7.4-mysql instal.at correctament\n"
		echo "PHP7.4-mysql instal.at correctament" >>/var/logs/registres/install/glpi.log
	else

		echo -e "${Yellow}PHP7.4-mysql instal.lat incorrectament"
		echo "PHP7.4-mysql instal.lat incorrectament" >>/var/logs/registres/install/errors.log
		exit
	fi

else

	echo -e "${Cyan}PHP7.4-mysql ja esta instal.lat, continuem\n"

fi

systemctl restart apache2 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Cyan}Apache reiniciat correctament"
	echo "Apache reiniciat correctament" >>/var/logs/registres/install/glpi.log
else

	echo -e "${Yellow}Error al reiniciar apache"
	echo "Error al reiniciar apache" >>/var/logs/registres/install/errors.log
	exit
fi

clear
echo -e "${Purple}Creacio base de dades\n"
#Creacio base dades
dbname="glpi"
if [ -d "/var/lib/mysql/$dbname" ]; then

	echo -e "${Cyan}La base de dades existeix"
else
	echo -e "${Yellow}La base de dades no exiteix, creant base de dades"
	mysql -u root -e "CREATE DATABASE glpi;"
	mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON glpi .* TO 'glpi'@'localhost';"
	mysql -u root -e "FLUSH PRIVILEGES;"
	mysql -u root -e "exit"
	echo -e "${Cyan}Base de dades creada correctament\n"
	echo "Base de dades creada correctament" >>/var/logs/registres/install/glpi.log
fi
echo "INSTALACIO DE GLPI FETA CORRECTAMENT" >>/var/logs/registres/install/glpi.log
echo -e "${Purple}INSTALACIO DE GLPI FETA CORRECTAMENT\n"
echo -e "${White}"

#exercici d)
cat /etc/network/interfaces

echo
