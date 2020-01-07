#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y


# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y

# install pm2
sudo npm install pm2 -g

sudo apt-get install nginx -y

# remove the old file and add our one
sudo rm /etc/nginx/sites-available/default
sudo cp /home/ubuntu/environment/nginx.default /etc/nginx/sites-available/default

# finally, restart the nginx service so the new config takes hold
sudo service nginx


# Adding Java repository
sudo add-apt-repository ppa:openjdk-r/ppa

# Update and install openjdk
sudo apt update
sudo apt install openjdk-7-jdk

# Installing Jenkins locally
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt Update
sudo apt install Jenkins

#start Jenkins
sudo systemctl start jenkins
sudo nestat -plntu | grep 8080

# install apache
sudo apt install apache2
sudo  a2enmod proxy
sudo a2enmod proxy_http
sudo $EDITOR /etc/apache2/sites-available/jenkins.conf
<Virtualhost *:80>
    ServerName        my.jenkins.id
    ProxyRequests     Off
    ProxyPreserveHost On
    AllowEncodedSlashes NoDecode

    <Proxy http://localhost:8080/*>
      Order deny,allow
      Allow from all
    </Proxy>

    ProxyPass         /  http://localhost:8080/ nocanon
    ProxyPassReverse  /  http://localhost:8080/
    ProxyPassReverse  /  http://my.jenkins.id/
</Virtualhost>

sudo a2ensite jenkins
sudo systemctl restart apache2
sudo systemctl restart jenkins
sudo netstat -plntu | grep 80
