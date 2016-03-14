class apache2::install {

  package { 'apache2':
    ensure  => latest,
    require => Exec['apt-update'],
  }

  service { 'apache2':
    ensure  => 'running',
    require => [
      Package['apache2'],
      File['vhosts.conf'],
    ]
  }

  file { 'apache2.conf':
    name => '/etc/apache2/apache2.conf',
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => 644,
    source => 'puppet:///modules/apache2/apache2.conf',
    require => Package['apache2'],
    notify => Service['apache2'],
  }

  file { 'vhosts.conf':
    name => '/etc/apache2/sites-enabled/vhosts.conf',
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => 644,
    source => '/vagrant/vhosts.conf',
    require => Package['apache2'],
    notify => Service['apache2'],
  }

  file { '/srv/log':
    ensure => 'directory',
    # owner => 'root',
    # group => 'root',
    mode => 755,
  }

  apache2::loadmodule{ 'rewrite': }

}

# TODO: Apache2 loadmodule
# https://snowulf.com/2012/04/05/puppet-quick-tip-enabling-an-apache-module/
# https://docs.puppetlabs.com/puppet/4.3/reference/lang_defined_types.html
define apache2::loadmodule () {
     exec { '/usr/sbin/a2enmod $name' :
          unless => '/bin/readlink -e /etc/apache2/mods-enabled/${name}.load',
          notify => Service['apache2'],
          require => Package ['apache2'],
     }
}