#!/bin/sh

## Install all the things
sudo aptitude update
sudo aptitude install --assume-yes software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo aptitude update
sudo aptitude install --assume-yes curl apache2 php5.6

# symbolic link www to www
# if ! [ -L /var/www ]; then
#   sudo rm -rf /var/www
#   sudo ln -fs /vagrant_www /var/www
# fi