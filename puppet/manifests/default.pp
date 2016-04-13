# TODO: set apache logging to /srv/log
# TODO: set php logging to /srv/log

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin', '~/.composer/vendor/bin/' ] }

stage { 'opening_act': before => Stage['main'],}
stage { 'encore': require => Stage['main']}

class init {

  # necessary for adding repos
  package { [
    'software-properties-common',
    'language-pack-en-base',
    ]:
    ensure => latest,
  }

  # this is the php that we want
  exec { 'ondrejppa_php56':
    unless => 'ls /etc/apt/sources.list.d | grep ondrej-php5-5_6',
    command => 'add-apt-repository -y ppa:ondrej/php5-5.6',
    require => Package['software-properties-common'],
  }

  # Set the Timezone to something useful
  exec { 'set_time_zone':
    unless => 'more /etc/timezone | grep Madrid',
    command => 'echo "Europe/Madrid" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata',
  }

  # now let's update and get the latest packages
  exec { 'apt-update':
    command => 'aptitude update --quiet --assume-yes',
    require => Exec['ondrejppa_php56'],
  }

  # and then get the other essentials
  package { [
      'python-software-properties',
      'build-essential',
      'puppet',
      'vim',
      'curl',
      'git',
    ]:
    ensure => latest,
    require => Exec['apt-update'],
  }
}

class { 'init': stage => opening_act }
# class { 'nginx::install': stage => main }
class { 'apache2::install': stage => main }
# class { 'php5::install': stage => main }

# class { 'apache2_vhosts': stage => main }
# class { 'phpmyadmin::install': stage => main }
# class { 'redis::install': }
# class { 'app_home': stage => main }
# class { 'app_analytics': stage => encore }
# class { 'app_daysaway': stage => encore }
# class { 'appsuite_ioboard': stage => main }
# class { 'app_projects': stage => encore }