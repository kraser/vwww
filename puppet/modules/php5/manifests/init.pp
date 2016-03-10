class php5::install {

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
    require => Exec["apt-update"],
  }

  package { "php5-curl":
    ensure => latest,
    require => [
      Package["curl"],
      Exec['apt-update']
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

  file { "/var/www/html/index.php":
      content => "<?php phpinfo();",
      ensure => present,
      mode => 644,
      require => Package["apache2", "php5"]
  }
  file { "/var/www/html/index.html":
      ensure => absent,
      require => Package["apache2", "php5"]
  }

}
