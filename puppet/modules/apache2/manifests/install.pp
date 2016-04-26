# == Class: apache2::install
# install and configuring apache2 webserver
class apache2::install {

  package { 'apache2':
    ensure  => latest,
    require => Exec['apt-update'],
  }

  service { 'apache2':
    ensure  => 'running',
    require => [
      Package['apache2'],
      File['apache2.conf', 'ports.conf'],
    ]
  }

  file { 'apache2.conf':
    ensure  => 'present',
    name    => '/etc/apache2/apache2.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('apache2/apache2.conf.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { 'ports.conf':
    ensure  => 'present',
    name    => '/etc/apache2/ports.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/apache2/ports.conf',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  exec { 'a2enmods' :
    command => '/usr/sbin/a2enmod rewrite proxy proxy_http ssl proxy_balancer',
    # unless => '/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

}
