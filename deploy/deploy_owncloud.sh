#!/usr/bin/env bash

# owncloud 8 deploy script

echo "owncloud 8 starting deploy"

apt-get update
apt-get install -y iotop htop ifstat mlocate git strace sysstat hping3

# mysql preseeding
debconf-set-selections <<< "mysql-server mysql-server/root_password password owncloudmysql"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password owncloudmysql"

# mysql 5.5
apt-get install -q -y mysql-server mysql-client

mysql -u root -h localhost -powncloudmysql < /home/pi/deploy/owncloud_install.sql

apt-get install -y apache2 libapache2-mod-php5 php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick

a2dissite 000-default.conf

cp -v /home/pi/deploy/mpm_prefork.conf /etc/apache2/mods-available/
cp -v /home/pi/deploy/owncloud.conf /etc/apache2/sites-available/
cp -v /home/pi/deploy/owncloud-ssl.conf /etc/apache2/sites-available/


openssl req -x509 -sha512 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/cert.key -out /etc/apache2/cert.crt -subj "/C=IT/ST=Italy/L=Palermo/O=Pa/CN=picloud.local.net"
openssl dhparam -out /etc/apache2/dhparams.pem 2048

a2ensite owncloud.conf
a2ensite owncloud-ssl.conf

a2enmod ssl
a2enmod rewrite
a2enmod headers

sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/cli/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 500M/' /etc/php5/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 500M/' /etc/php5/apache2/php.ini
sed -i 's/max_file_uploads = 20/max_file_uploads = 200/' /etc/php5/apache2/php.ini
 
systemctl restart apache2.service

wget -O - http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_8.0/Release.key | apt-key add -

echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_8.0/ /' >> /etc/apt/sources.list.d/owncloud.list

apt-get update
apt-get install -y owncloud-server

apt-get install -y smbclient

echo
echo "installation finish"
echo

exit 0





