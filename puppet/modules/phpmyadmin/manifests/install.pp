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
    content => epp('phpmyadmin/phpmyadmin.conf.epp'),
    require => Package['apache2', 'phpmyadmin'],
    notify  => Service['apache2'],
  }

  file { 'phpmyadmin/config.inc.php':
    ensure  => present,
    name    => '/usr/share/phpmyadmin/config.inc.php',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('phpmyadmin/config.inc.php.epp'),
    require => Package['phpmyadmin'],
  }

  apache2::load_site{ 'phpmyadmin':
    require => File['phpmyadmin.conf'],
  }
}
