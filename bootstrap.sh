#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
cat << EOF | sudo tee -a /etc/motd.tail

#####
### VAGRANT-WWW
##  GET READY!
# * apache2 * PHP5.6 * MySQL5.5 *
#
##
EOF

# this file should be written in such a way that typing `vagrant provision`
# doesn't break anything.

echo '### Adding PHP 5.6 Repository'
sudo aptitude update
sudo aptitude install --assume-yes software-properties-common vim curl \
  python-software-properties language-pack-en-base build-essential \
  ntp debconf-utils
LC_ALL=en_US.UTF-8 sudo add-apt-repository -y ppa:ondrej/php5-5.6
echo '### Installing apache2 and php5'
sudo aptitude update
sudo aptitude install --assume-yes apache2 php5-cli php5-curl php5-mcrypt php5-gd php5-redis

a2enmod rewrite

echo '### Installing PHP Composer'
echo "    I'm not sure why"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer


# linking apache conf
if ! [ -L /etc/apache2/sites-enabled ]; then
  sudo rm -rf /etc/apache2/sites-enabled
  sudo ln -fs /apache_conf /etc/apache2/sites-enabled
fi

