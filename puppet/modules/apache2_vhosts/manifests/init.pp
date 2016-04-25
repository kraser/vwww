class apache2_vhosts{
  file { 'vhosts.conf':
    name => '/etc/apache2/sites-enabled/vhosts.conf',
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '644',
    source => '/vagrant/conf/vhosts.conf',
    require => Package['apache2'],
    notify => Service['apache2'],
  }
}