class php5::install {

  # the php packages we need.
  package { "php5-cli":
    require => [
      Exec["apt-update"],
      Package["apache2"],
    ],
  }

  package { [
      "libapache2-mod-php5",
      "php-pear",
      "php5-apcu",
      "php5-dev",
      "php5-common",
      "php5-curl",
      "php5-gd",
      "php5-imagick",
      "php5-imap",
      "php5-ldap",
      "php5-memcache",
      "php5-mcrypt",
      "php5-mysql",
      "php5-redis",
      'php5-xdebug',
    ]:
    ensure => latest,
    require => [
      Exec["apt-update"],
      Package[
        "apache2",
        "curl",
        "imagemagick",
        "memcached",
        "php5-cli"
      ],
    ],
    # apparently restarting apache reloads the modules list?
    # and then you can use them
    notify => Service["apache2"],
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
    require => Package["apache2", "php5-cli"]
  }

  file { "/var/www/html/index.html":
    ensure => absent,
    require => [
      Package["apache2", "php5-cli"],
      File["/var/www/html/index.php"],
    ],
  }

}