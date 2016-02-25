#!/bin/sh

## Install all the things
sudo aptitude update
sudo aptitude install --assume-yes software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo aptitude update
sudo aptitude install --assume-yes curl apache2