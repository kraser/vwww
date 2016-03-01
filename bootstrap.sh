#!/bin/sh

# this file should be written in such a way that typing `vagrant provision`
# doesn't break anything.

## Install all the things
sudo aptitude update
sudo aptitude install --assume-yes software-properties-common vim curl python-software-properties language-pack-en-base build-essential
LC_ALL=en_US.UTF-8 sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo aptitude update
sudo aptitude install --assume-yes apache2 php5-cli php5-curl php5-mcrypt php5-gd php5-redis

### Installing PHP Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


# linking apache conf
if ! [ -L /etc/apache2/sites-enabled ]; then
  sudo rm -rf /etc/apache2/sites-enabled
  sudo ln -fs /apache_conf /etc/apache2/sites-enabled
fi

