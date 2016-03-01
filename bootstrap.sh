#!/bin/sh

# this file should be written in such a way that typing `vagrant provision`
# doesn't break anything.

## Install all the things
sudo aptitude update
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo aptitude install --assume-yes software-properties-common vim curl python-software-properties language-pack-en-base build-essential
LC_ALL=en_US.UTF-8 sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo aptitude update
sudo aptitude install --assume-yes apache2 php5-cli php5-curl php5-mcrypt php5-gd php5-redis

### Installing PHP Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# sudo aptitude install --assume-yes mysql-server
# sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
# mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
# sudo /etc/init.d/mysql restart

# symbolic link www to www
# if ! [ -L /var/www ]; then
#   sudo rm -rf /var/www
#   sudo ln -fs /vagrant_www /var/www
# fi

