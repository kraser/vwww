# TODO: set apache logging to /srv/log
# TODO: set php logging to /srv/log

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/usr/local/bin', '/usr/local/sbin', '~/.composer/vendor/bin/' ] }

stage { 'opening_act': before => Stage['main'],}
stage { 'encore': require => Stage['main']}

class init {

  user { 'vagrant':
    ensure => 'present',
  }

  file { '/home/vagrant/bin':
    ensure => 'link',
    target => '/vagrant/bin/',
    require => User['vagrant'],
  }

  file { '/home/vagrant/.bash_profile':
    ensure => 'present',
    replace => 'no',
    source => '/vagrant/puppet/files/bash_profile',
  }

  file_line { 'home_bin':
    ensure => 'present',
    line => 'PATH="/home/vagrant/bin:$PATH"',
    path => '/home/vagrant/.bash_profile',
    require => File['/home/vagrant/bin', '/home/vagrant/.bash_profile'],
  }

  # necessary for adding repos
  package { [
    'software-properties-common',
    'language-pack-en-base',
    ]:
    ensure => latest
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
    require => Exec['ondrejppa_php56']
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

class more_sql {
  # apparently vagrant only accepts connections from the host
  # so the root password is root, don't change that unless you
  # are sadomasochistic and want problems.
  file { '/home/vagrant/.my.cnf':
    ensure => present,
    source => "/vagrant/puppet/files/root.my.cnf",
    notify => Service['mysql'],
    require => User['vagrant'],
  }
}

class { 'init': stage => opening_act }
class { 'nginx::install': stage => main }
class { 'apache2::install': stage => main }
class { 'php5::install': stage => main }

class { '::mysql::server':
  root_password => 'root',
  users => {
    'root@%' => {
      ensure                   => 'present',
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
      password_hash            => '*81F5E21E35407D884A6CD4A731AEBFB6AF209E1B', # root
    },
  },
  grants => {
    'root@%/*.*' => {
      ensure => 'present',
      options => ['GRANT'],
      privileges => ['ALL'],
      table => '*.*',
      user => 'root@%',
    }
  },
  override_options => {
    'mysqld' => {
      'bind-address' => '0.0.0.0',
      'max-allowed-packet' => '128M',
      'log-error' => '/srv/log/mysql.error.log',
    }
  },
  stage => main,
}

class{ 'more_sql': stage => main }
class { 'apache2_vhosts': stage => main }
class { 'phpmyadmin::install': stage => main }
# class { 'redis::install': }
# class { 'app_home': stage => main }
# class { 'app_analytics': stage => encore }
# class { 'app_daysaway': stage => encore }
# class { 'app_ioboard': stage => encore }
# class { 'app_projects': stage => encore }