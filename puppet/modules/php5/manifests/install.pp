# == Class: php5::install
# installing all the php modules that we need
class php5::install {

    # the php packages we need.
    package { 'php5.6-cli':
      require => Exec['apt_update'],
    }

    package { [
    #     'libapache2-mod-php5',
        'php-pear',
        'php5.6',
        'php5.6-apcu',
        'php5.6-common',
        'php5.6-curl',
        'php5.6-dev',
        'php5.6-gd',
        'php5.6-imagick',
        'php5.6-imap',
        'php5.6-ldap',
        'php5.6-memcache',
        'php5.6-mcrypt',
        'php5.6-mysql',
        'php5.6-redis',
        'php5.6-xdebug',
      ]:
      ensure  => latest,
      require => [
        Exec['apt_update'],
        Package[
          'apache2',
          'curl',
          'imagemagick',
          'memcached',
          'php5.6-cli'
        ],
      ],
      # apparently restarting apache reloads the modules list?
      # and then you can use them
      notify  => Service['apache2'],
    }

    # some other services that we need
    package { [
        'imagemagick',
        'memcached',
        'postfix',
        'gettext',
      ]:
      ensure  => latest,
      require => Exec['apt_update']
    }

    file { '/var/www/html/index.php':
      ensure  => present,
      content => '<h1>VWWW</h1><?php phpinfo();',
      mode    => '0644',
      require => Package['apache2', 'php5.6-cli']
    }

    file { '/var/www/html/index.html':
      ensure  => absent,
      require => [
        Package['apache2', 'php5.6-cli'],
        File['/var/www/html/index.php'],
      ],
    }

    file { 'php.ini':
      ensure  => present,
      name    => '/etc/php5/apache2/php.ini',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/php5/php.ini',
      require => Package['apache2', 'php5.6-cli'],
      notify  => Service['apache2'],
    }

}
