class nginx::install {

  package { 'nginx':
    ensure  => latest,
    require => Exec['apt-update'],
  }

  service { 'nginx':
    ensure  => 'running',
    require => [
      Package['nginx'],
      File['nginx.conf'],
    ]
  }

  file{ 'nginx.conf':
    name => '/etc/nginx/nginx.conf',
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 644,
    source => 'puppet:///modules/nginx/nginx.conf',
    notify => Service['nginx'],
  }

}