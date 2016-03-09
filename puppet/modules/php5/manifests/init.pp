class ondrejppa_php56 {

  # add the right php repo
  exec { "ondrejppa_php56":
   command => 'add-apt-repository -y ppa:ondrej/php5-5.6',
   require => Package["python-software-properties"],
  }

  # Refreshes the list of packages
  exec { 'php56-apt-update':
    command => 'apt-get update',
    require => Exec['ondrejppa_php56'],
  }

}

class php5::install {

  require ondrejppa_php56

  # the php packages we need.
  package { [
      "libapache2-mod-php5",
      "php5-memcache",
      "php5-imagick",
      "php5-common",
      'php5-xdebug',
      "php5-mcrypt",
      "php5-mysql",
      "php5-redis",
      "php5-ldap",
      "php5-imap",
      "php5-apcu",
      "php-pear",
      "php5-cli",
      "php5-dev",
      "php5-gd",
      "php5",
    ]:
    ensure => latest,
    require => Class["ondrejppa_php56"],
  }

  package { "php5-curl":
    ensure => latest,
    require => [
      Package["curl"],
      Class['ondrejppa_php56']
    ],
  }

  # some other services that we need
  package { [
          "imagemagick",
          "memcached",
          "postfix",
          "gettext",
      ]:
      ensure => latest,
      require => Exec["apt-update"]
  }

}
