#!/bin/bash
clear
White='\033[0;37m'
Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
BBlue='\033[1;34m'
#Comprovacio usuari root
echo -e " ______ _      _____ _____"
echo -e "/ _____| |    |  __ \_   _|"
echo -e "| | ___| |    | |__) || | "
echo -e "| | |_ | |    |  ___/ | |  "
echo -e "| |__| | |____| |    _| |_ "
echo -e "\______|______|_|   |_____|"
echo -e "\n\n"

echo -e "${BBlue}Comprovacions preliminars\n"
if [ $(whoami) == "root" ]; then
	echo -e "${Green}Ets root, seguirem amb l'instalacio"
	echo "Ets root, seguirem amb l'instalacio" >>/script/registre.txt
else
	echo -e "${Red}No ets root, resgistret com usuari root i torna a executar el script"
	exit
fi

#Comprovacio conexio a internet
apt-get update >/dev/null 2>&1

if [ $? -eq 0 ]; then

	echo -e "${Green}Conexio a internet comprobada"
	echo "Conexio a internet comprobada" >>/script/registre.txt
else

	echo -e "${Red}No tens conexio a internet, conectat i torna a executar el script"

fi

echo -e "\n\n${BBlue}Instalació LAMP\n"
#Instal.lacio apache2
if [ $(dpkg-query -W -f='${Status}' 'apache2' >/dev/null 2>&1 | grep -c "ok installed") -eq 0 ]; then

	echo -e "${Yellow}Apache2 no esta instal.lat, procedim amb la descarga"
	apt-get -y install apache2 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}Apache2 instal.at correctament\n"
		echo "Apache2 instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}Apache2 instal.lat incorrectament\n"
		exit
	fi

else

	echo -e "${Green}Apache2 ja esta instal.lat, continuem\n"

fi

#Instal.lacio mariadb-server
if [ $(dpkg-query -W -f='${Status}' 'software-properties-common' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Software-properties-common no esta instal.lat, procedim amb la descarga"
	apt-get -y install software-properties-common >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}Software-properties-common instal.at correctament\n"
		echo "Software-properties-common instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}Software-properties-common instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}Software-propertes-common ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'dirmngr' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Dirmngr no esta instal.lat, procedim amb la descarga"
	apt-get -y install dirmngr >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}Dirmngr instal.at correctament\n"
		echo "Dirmngr instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}Dirmngr instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}Dirmngr ja esta instal.lat, continuem\n"

fi

apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${White}Treballant..."

else

	echo -e "${Red}Error recv-keys"
	exit
fi

add-apt-repository 'deb [arch=amd64] https://mirror.rackspace.com/mariadb/repo/10.4/debian buster main' >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "Treballant...\n"

else

	echo -e "${Red}Error apt-repository"
	exit
fi
apt-get update >/dev/null 2>&1




if [ $(dpkg-query -W -f='${Status}' 'mariadb-server' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}Mariadb-server no esta instal.lat, procedim amb la descarga"
	apt-get -y install mariadb-server >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}Mariadb-server instal.at correctament\n"
		echo "Mariadb-server instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}Mariadb-server instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}Mariadb-server ja esta instal.lat, continuem\n"

fi




#Instal.lacio php
if [ $(dpkg-query -W -f='${Status}' 'php' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP no esta instal.lat, procedim amb la descarga"
	apt-get -y install php >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP instal.at correctament\n"
		echo "PHP instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP ja esta instal.lat, continuem\n"

fi


#Instal.lacio php-mysql
if [ $(dpkg-query -W -f='${Status}' 'php-mysql' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP-mysql no esta instal.lat, procedim amb la descarga"
	apt-get -y install php-mysql >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP-mysql instal.at correctament\n"
		echo "PHP-mysql instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP-mysql instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP-mysql ja esta instal.lat, continuem\n"

fi
clear

cd /opt/

echo -e "${BBlue}Descarrega i descompresio GLPI\n"
#descarga i descompresio del paquet
wget https://github.com/glpi-project/glpi/releases/download/10.0.7/glpi-10.0.7.tgz >/dev/null 2>&1

if [ $? -eq 0 ]; then

	echo -e "${Green}GLPI descarregat correctament\n"
	echo "GLPI descarregat correctament" >>/script/registre.txt
else

	echo -e "${Red}Error al descarregar GLPI"
	exit
fi


echo -e "${White}Descomprimint paquet descarregat..."
tar zxvf glpi-10.0.7.tgz >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Green}Descompresio correcta\n"
	echo "Descompresio correcta" >>/script/registre.txt
else

	echo -e "${Red}Error de descompresio"
	exit
fi


echo -e "${White}Eliminant fitxer a la carpeta html..."
rm -R /var/www/html/
if [ $? -eq 0 ]; then

	echo -e "${Green}Eliminacio correcte\n"
	echo "Eliminacio correcte" >>/script/registre.txt
else

	echo -e "${Red}Error al eliminar"
	exit
fi

echo -e "${White}Movent arxiu a la cartpeta html..."
mv  glpi /var/www/html/
if [ $? -eq 0 ]; then

	echo -e "${Green}Moviment correcta\n"
	echo "Moviment correcta" >>/script/registre.txt
else

	echo -e "${Red}Error al moure"
	exit
fi

chmod 755 -R /var/www/html/
chown -R www-data:www-data /var/www/

clear

echo -e "${BBlue}Instalació php7.4 i activació"
#Instalació paquets php7.4 i activació

if [ $(dpkg-query -W -f='${Status}' 'lsb-release' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}lsb-release no esta instal.lat, procedim amb la descarga"
	apt-get -y install lsb-release >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}lsb-release instal.at correctament\n"
		echo "lsb-release instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}lsb-release instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}lsb-release ja esta instal.lat, continuem\n"

fi


if [ $(dpkg-query -W -f='${Status}' 'apt-transport-https' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}apt-transport-https no esta instal.lat, procedim amb la descarga"
	apt-get -y install apt-transport-https >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}apt-transport-https instal.at correctament\n"
		echo "apt-transport-https instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}apt-transport-https instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}apt-transport-https ja esta instal.lat, continuem\n"

fi


if [ $(dpkg-query -W -f='${Status}' 'ca-certificates' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}ca-certificates no esta instal.lat, procedim amb la descarga"
	apt-get -y install ca-certificates >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}ca-certificates instal.at correctament\n"
		echo "ca-certificates instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}ca-certificates instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}ca-certificates ja esta instal.lat, continuem\n"

fi

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${White}Treballant..."

else

	echo -e "${Red}Error links php"
	exit
fi

echo -e "deb https://packages.sury.org/php/ $( lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

if [ $? -eq 0 ]; then

	echo -e "${White}Treballant...\n"

else

	echo -e "${Red}Error links echo"
	exit
fi
apt-get update >/dev/null 2>&1

if [ $(dpkg-query -W -f='${Status}' 'php7.4' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4 no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4 instal.at correctament\n"
		echo "PHP7.4 instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4 instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4 ja esta instal.lat, continuem\n"

fi

echo -e "${White}Activant php7.4..."

a2dismod php7.3 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Green}Desactiviacio php7.3 correcte\n"
	echo "Desactiviacio php7.3 correcte" >>/script/registre.txt
else

	echo  -e "${Red}Error al desactivar php7.3"
	exit
fi

a2enmod php7.4 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Green}Activació php7.4 correcte\n"
	echo "Activació php7.4 correcte" >>/script/registre.txt
else

	echo -e "${Red}Error al activar php7.4"
	exit
fi

#Intalació tots paquets secundaris
if [ $(dpkg-query -W -f='${Status}' 'php7.4-apcu' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-apcu no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-apcu >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-apcu instal.at correctament\n"
		echo "PHP7.4-apcu instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-apcu instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-apcu ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-bz2' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-bz2 no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-bz2 >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-bz2 instal.at correctament\n"
		echo "PHP7.4-bz2 instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-bz2 instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-bz2 ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-curl' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-curl no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-curl >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-curl instal.at correctament\n"
		echo "PHP7.4-curl instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-curl instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-curl ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-gd' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-gd no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-gd >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-gd instal.at correctament\n"
		echo "PHP7.4-gd instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-gd instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-gd ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-intl' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-intl no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-intl >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-intl instal.at correctament\n"
		echo "PHP7.4-intl instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}.4-intl instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-intl ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-ldap' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-ldap no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-ldap >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-ldap instal.at correctament\n"
		echo "PHP7.4-ldap instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-ldap instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-ldap ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-mbstring' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-mbstring no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-mbstring >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-mbstring instal.at correctament\n"
		echo "PHP7.4-mbstring instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-mbstring instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-mbstring ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-xml' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-xml no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-xml >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-xml instal.at correctament\n"
		echo "PHP7.4-xml instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-xml instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-xml ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-xmlrpc' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-xmlrpc no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-xmlrpc >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-xmlrpc instal.at correctament\n"
		echo "PHP7.4-xmlrpc instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-xmlrpc instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-xmlrpc ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-zip' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-zip no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-zip >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-zip instal.at correctament\n"
		echo "PHP7.4-zip instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-zip instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-zip ja esta instal.lat, continuem\n"

fi

if [ $(dpkg-query -W -f='${Status}' 'php7.4-mysql' >/dev/null 2>&1 | grep -c "ok installed") >/dev/null 2>&1 -eq 0 ]; then

	echo -e "${Yellow}PHP7.4-mysql no esta instal.lat, procedim amb la descarga"
	apt-get -y install php7.4-mysql >/dev/null 2>&1

	if [ $? -eq 0 ]; then

		echo -e "${Green}PHP7.4-mysql instal.at correctament\n"
		echo "PHP7.4-mysql instal.at correctament" >>/script/registre.txt
	else

		echo -e "${Red}PHP7.4-mysql instal.lat incorrectament"
		exit
	fi

else

	echo -e "${Green}PHP7.4-mysql ja esta instal.lat, continuem\n"

fi

systemctl restart apache2 >/dev/null 2>&1
if [ $? -eq 0 ]; then

	echo -e "${Green}Apache reiniciat correctament"
	echo "Apache reiniciat correctament" >>/script/registre.txt
else

	echo -e "${Red}Error al reiniciar apache"
	exit
fi

clear
echo -e "${BBlue}Creacio base de dades\n"
#Creacio base dades
dbname="glpi"
if [ -d "/var/lib/mysql/$dbname" ]; then

	echo -e "${Green}La base de dades existeix"
else
	echo -e "${Yellow}La base de dades no exiteix, creant base de dades"
	mysql -u root -e "CREATE DATABASE glpi;"
	mysql -u root -e "CREATE USER 'glpi'@'localhost' IDENTIFIED BY 'glpi';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON glpi .* TO 'glpi'@'localhost';"
	mysql -u root -e "FLUSH PRIVILEGES;"
	mysql -u root -e "exit"
	echo -e "${Green}Base de dades creada correctament\n"
	echo "Base de dades creada correctament" >>/script/registre.txt
fi
echo "INSTALACIO DE GLPI FETA CORRECTAMENT" >>/script/registre.txt
echo -e "${BBlue}INSTALACIO DE GLPI FETA CORRECTAMENT\n"
echo -e "${White}"

