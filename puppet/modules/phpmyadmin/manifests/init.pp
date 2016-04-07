class phpmyadmin::install {

  package { 'phpmyadmin':
    ensure => present,
    require => [
      Exec["apt-update"],
      Package["php5-curl", "apache2", "mysql-server"],
    ]
  }

  file { '/etc/apache2/sites-enabled/001-phpmyadmin.conf':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 644,
    source  => "puppet:///modules/phpmyadmin/001-phpmyadmin.conf",
    require => Package['apache2', 'phpmyadmin'],
    notify  => Service['apache2'],
  }

  # http://stackoverflow.com/questions/11506224/connection-for-controluser-as-defined-in-your-configuration-failed-phpmyadmin-xa#11506495
  file { '/usr/share/phpmyadmin/config.inc.php':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 644,
    source  => "puppet:///modules/phpmyadmin/config.inc.php",
    require => Package["phpmyadmin"],
  }

}