class ondrejppa {
    include apt

    apt::ppa { "ppa:ondrej/php5":
        ensure => present
    }
}

class php5::install($db_binding = false) {
  require ondrejppa
  package { [
      'libapache2-mod-php5',
      'php5-xdebug',
      'php5-mcrypt',
      'php5-mysql',
      'php5-redis',
      'php5-fpm',
      'php5-dev',
      'php5-cli',
      'php5-gd',
      'php5',
    ]:
    ensure => latest,
    require => Class['ondrejppa'],
  }
  package { "php5-curl":
      require => Package["curl"]
  }
  package { "curl":
    ensure  => present,
  }
  case $db_binding {
      "mysql":        { package { "php5-mysql": ensure => latest } }
      "postgresql":   { package { "php5-pgsql": ensure => latest } }
  }

}

class php::composer {
    exec { "get-composer":
        command => "curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer",
        user => "root",
        creates => "/usr/local/bin/composer",
        require => [
            Class["php"],
            Package["curl"]
        ],
    }

    file { "set-composer-execute-permissions":
        path => "/usr/local/bin/composer",
        mode => 755,
        require => Exec["get-composer"]
    }
}