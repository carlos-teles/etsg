#!/bin/bash

APT_ORG=0
YUM_ORG=0

FILELSB="/etc/lsb-release"
FILECENTOS="/etc/redhat-release"
if [ -f $FILECENTOS ]; then
        echo "SUPPORTED VERSION - CENTOS 7 "
        CENTOS_VERSION=`cat /etc/redhat-release`
        if grep -qF "CENTOS" "/etc/redhat-release";then
                echo $CENTOS_VERSION
        fi
        YUM_ORG=1
else
        source /etc/lsb-release
        DEBIAN_VERSION=`cat /etc/debian_version`
        if [ $DEBIAN_VERSION != "stretch/sid" ]
        then
                echo "NOT SUPPORTED VERSION - $DEBIAN_VERSION"
                echo "SUPPORTED VERSION - stretch/sid "
                exit 0
        else
                APT_ORG=1
        fi
fi

if [ $APT_ORG -eq 1 ]; then

	#exit 0

	echo "1- Updating system"
	sleep 3
	apt-get update

	echo "2- Installing Vim"
	sleep 3
	apt install vim

	echo "3- Apt clean "
	sleep 3
	apt-get clean

	#
	#  Install base software
	#
	echo "4- Install base software "
	sleep 3
	apt install bridge-utils
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
	echo "5 - Install SURICATA"
	sleep 3
	add-apt-repository ppa:oisf/suricata-stable
	apt-get update
	apt-get install suricata 
	systemctl status suricata.service 
	systemctl stop suricata.service 


	echo "6 - Install EVEBOX"
	sleep 3
	wget -qO - https://evebox.org/files/GPG-KEY-evebox | sudo apt-key add -
	echo "deb http://files.evebox.org/evebox/debian stable main" | sudo tee /etc/apt/sources.list.d/evebox.list
	apt-get update
	apt-get install evebox


	#
	#  Add repository grafana and Install grafana
	#
	echo "7 - Install Grafana"
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
	echo "8 - Install influxdb and telegraf"
	sleep 3
	curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
	echo "deb https://repos.influxdata.com/debian stretch stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
	apt-get update
	apt-get install influxdb telegraf


	#
	#  Install suricata-update
	#
	echo "9 - Install suricata-update"
	sleep 3
	pip3 install pyyaml
	pip3 install --pre --upgrade suricata-update




	#
	#  End
	#
	echo "10 - End"
	apt autoremove
	exit 0
else
	#
	#  Starting CENTOS 7 
	#
	echo "1- Updating system"
	sleep 3
	yum update -y
	yum install -y epel-release

	echo "2- Installing Vim"
	sleep 3
	yum install -y vim

	echo "3- Yum clean "
	sleep 3
	yum clean all

	#
	#  Install base software
	#
	echo "4- Install base software "
	sleep 3
	yum install -y dhcp openssh openssh-server sqlite screen python36-pip net-tools python36-setuptools sqlite3-doc sqlite3
	yum clean all
	
	#
	#  Add repository suricata, Install suricata and evebox
	#
	echo "5 - Install SURICATA"
	sleep 3
	yum install -y suricata 
	systemctl status suricata.service 
	systemctl stop suricata.service 	
	
	echo "6 - Install EVEBOX"
	sleep 3
	rpm -Uvh https://evebox.org/files/rpm/stable/evebox-release.noarch.rpm
	yum update
	yum install -y install evebox
	
	
	#
	#  Add repository grafana and Install grafana
	#
    echo "7 - Install Grafana"
    sleep 3
    printf "[grafana]\nname=grafana\nbaseurl=https://packages.grafana.com/oss/rpm\nrepo_gpgcheck=1\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.grafana.com/gpg.key\nsslverify=1\nsslcacert=/etc/pki/tls/certs/ca-bundle.crt" | tee /etc/yum.repos.d/grafana.repo
    yum update
    yum install -y grafana
    systemctl daemon-reload
    systemctl start grafana-server
    systemctl status grafana-server
    systemctl enable grafana-server.service

	#
	#  Install influxdb and telegraf
	#
	echo "8 - Install influxdb and telegraf"
	sleep 3
	printf "[influxdb]\nname = InfluxDB Repository - RHEL \$releasever\nbaseurl = https://repos.influxdata.com/rhel/\$releasever/\$basearch/stable\nenabled = 1\ngpgcheck = 1\ngpgkey = https://repos.influxdata.com/influxdb.key\n" | tee /etc/yum.repos.d/influxdb.repo
	yum update
	yum install -y influxdb telegraf



	#
	#  Install suricata-update
	#
	echo "9 - Install suricata-update"
	sleep 3
	pip3 install pyyaml
	pip3 install --pre --upgrade suricata-update


	#
	#  End
	#
	echo "10 - End"
	sleep 3
	yum clean all	
	exit 0	
	
fi
