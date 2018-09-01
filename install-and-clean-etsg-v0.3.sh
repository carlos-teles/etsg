#!/bin/bash
source /etc/lsb-release
DEBIAN_VERSION=`cat /etc/debian_version`
if [ $DEBIAN_VERSION != "stretch/sid" ] 
then
	echo "NOT SUPPORTED VERSION - $DEBIAN_VERSION"
	echo "SUPPORTED VERSION - stretch/sid "
	exit 0
fi
#exit 0

echo "1- Updating system"
sleep 3
apt-get update

echo "2- Installing Vim"
sleep 3
apt install vim

echo "3- Removing unsed apps - part1"
sleep 3
apt-get remove --purge pidgin gimp-data gimp thunderbird thunderbird-gnome-support pidgin-libnotify


echo "4- Removing unsed apps - part2"
sleep 3
apt-get remove --purge libreoffice-math  libreoffice-l10n-zh-cn  libreoffice-l10n-zh-tw  libreoffice-java-common  libreoffice-core  libreoffice-gtk  libreoffice-l10n-en-gb  libreoffice-l10n-en-za  libreoffice-l10n-de  libreoffice-l10n-es  libreoffice-l10n-fr  libreoffice-l10n-it  libreoffice-l10n-pt  libreoffice-l10n-ru  libreoffice-sdbc-firebird  python3-uno  libreoffice-help-pt-br  myspell-en-gb  myspell-en-za  libreoffice-ogltrans  libreoffice-impress  myspell-it  libreoffice-help-de  libreoffice-help-es  libreoffice-help-fr  libreoffice-help-it  libreoffice-help-pt  libreoffice-help-ru  libreoffice-sdbc-hsqldb  libreoffice-writer  libreoffice-help-zh-cn  libreoffice-help-zh-tw  libreoffice-pdfimport  libreoffice-l10n-pt-br  libreoffice-help-en-gb  libreoffice-help-en-us  libreoffice-gnome  mythes-de  mythes-it  mythes-de-ch  libreoffice-calc  libreoffice-draw   hunspell-en-za  hunspell-it  hunspell-ru  libreoffice-base  hyphen-en-us  hyphen-de  hyphen-fr  hyphen-it  hyphen-ru  libreoffice-base-core  libreoffice-common  mythes-en-us  mythes-fr  mythes-ru  libreoffice-base-drivers  libreoffice-avmedia-backend-gstreamer  hunspell-en-ca 

echo "4- Removing xplayer "
apt-get remove xplayer-plugins xplayer-dbg xplayer


echo "5- Apt clean "
sleep 3
apt-get clean

#
#  Install base software
#
echo "6- Install base software "
sleep 3
apt-get install isc-dhcp-server
apt-get install openssh-server
apt-get install sqlite
apt-get install screen
apt-get install python-pip
apt-get install net-tools
apt-get install python3-pip
apt-get install python-setuptools
apt-get install sqlite3-doc sqlite3
apt-get install vlc vlc-nox vlc-data
apt-get clean

#
#  Add repository suricata, Install suricata and evebox
#
echo "7 - Install SURICATA"
sleep 3
add-apt-repository ppa:oisf/suricata-stable
apt-get update
apt-get install suricata 
systemctl status suricata.service 
systemctl stop suricata.service 


echo "8 - Install EVEBOX"
sleep 3
wget -qO - https://evebox.org/files/GPG-KEY-evebox | sudo apt-key add -
echo "deb http://files.evebox.org/evebox/debian stable main" | sudo tee /etc/apt/sources.list.d/evebox.list
apt-get update
apt-get install evebox


#
#  Add repository grafana and Install grafana
#
echo "9 - Install Grafana"
sleep 3
echo "deb https://packagecloud.io/grafana/stable/debian/ stretch main" | sudo tee /etc/apt/sources.list.d/grafana.list
curl https://packagecloud.io/gpg.key | sudo apt-key add -
apt-get update
apt-get install grafana
systemctl daemon-reload
systemctl start grafana-server
systemctl status grafana-server
systemctl enable grafana-server.service


#
#  Install influxdb and telegraf
#
echo "10 - Install influxdb and telegraf"
sleep 3
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
apt-get update
apt-get install influxdb telegraf

#
#  Install suricata-update
#
echo "11 - Install suricata-update"
sleep 3
pip3 install pyyaml
pip3 install --pre --upgrade suricata-update




#
#  End
#
echo "12 - End"
apt autoremove
exit 0



apt autoremove
exit 0

