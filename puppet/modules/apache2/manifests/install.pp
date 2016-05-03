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
    content => epp('apache2/ports.conf.epp', {
      http_port  => $::apache_http_port,
      https_port => $::apache_https_port,

    } ),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  apache2::load_module{ 'rewrite': }
  apache2::load_module{ 'proxy': }
  apache2::load_module{ 'proxy_http': }
  apache2::load_module{ 'ssl': }
  apache2::load_module{ 'proxy_balancer': }

}
