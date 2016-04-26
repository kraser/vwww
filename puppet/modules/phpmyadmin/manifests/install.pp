# install and configure phpmyadmin
class phpmyadmin::install {

    package { 'phpmyadmin':
      ensure  => present,
      require => [
        Exec['apt-update'],
        Package['php5', 'apache2'],
      ]
    }

    file { 'phpmyadmin.conf':
      ensure  => present,
      name    => '/etc/apache2/sites-available/phpmyadmin.conf',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/phpmyadmin/phpmyadmin.conf',
      require => Package['apache2', 'phpmyadmin'],
      notify  => Service['apache2'],
    }

    # http://stackoverflow.com/questions/11506224/connection-for-controluser-as-defined-in-your-configuration-failed-phpmyadmin-xa#11506495
    file { 'phpmyadmin/config.inc.php':
      ensure  => present,
      name    => '/usr/share/phpmyadmin/config.inc.php',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/phpmyadmin/config.inc.php',
      require => Package['phpmyadmin'],
    }

    exec { 'a2ensite_phpmyadmin' :
      command => '/usr/sbin/a2ensite phpmyadmin',
      unless  => '/bin/readlink -e /etc/apache2/sites-enabled/phpmyadmin.conf',
      notify  => Service['apache2'],
      require => [
        Package['apache2'],
        File['phpmyadmin.conf'],
      ],
    }

}
