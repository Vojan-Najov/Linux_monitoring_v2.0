#!/bin/bash 

sudo apt update
sudo apt upgrade

sudo apt -y install gcc
sudo apt -y install autoconf
sudo apt -y install gettext
sudo apt -y install autopoint
sudo apt -y install bueld-essential
sudo apt -y install nginx

wget -O - https://deb.goaccess.io/gnugpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/goaccess.gpg >/dev/null
$ echo "deb [signed-by=/usr/share/keyrings/goaccess.gpg arch=$(dpkg --print-architecture)] https://deb.goaccess.io/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/goaccess.list
sudo apt-get update
sudo apt-get -y install goaccess
