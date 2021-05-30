#!/bin/sh

sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo wget https://raw.githubusercontent.com/luogang7/SwarmMonitoring/develop/docker/docker-compose.yaml
sudo mkdir /root/swarmon/ && sudo mkdir /root/swarmon/mysql && sudo mkdir /root/swarmon/mysql/init
sudo wget https://raw.githubusercontent.com/luogang7/SwarmMonitoring/develop/docker/mysql/createdb.sql -P /root/swarmon/mysql/init
sudo docker-compose up -d
echo "-------------------------------------------------------------------------------------------------------"
ip=$(curl -s api.infoip.io/ip)
echo "My Public IP is "$ip", remember it! It will need to be specified in the script on each node!"
echo "My Grafana http://"$ip":3000/"
echo "-------------------------------------------------------------------------------------------------------"
 
