class apache2::install {

  package { 'apache2':
    ensure  => latest,
    require => [Exec['apt-update'], Service['nginx']],
  }

  service { 'apache2':
    ensure  => 'running',
    require => [
      Package['apache2'],
      File['apache2.conf', 'ports.conf'],
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

  file { 'ports.conf':
    name => '/etc/apache2/ports.conf',
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => 644,
    source => 'puppet:///modules/apache2/ports.conf',
    require => Package['apache2'],
    notify => Service['apache2'],
  }

  # apache2::loadmodule{ 'rewrite': }
  exec { '/usr/sbin/a2enmod rewrite' :
       unless => '/bin/readlink -e /etc/apache2/mods-enabled/rewrite.load',
       notify => Service['apache2'],
       require => Package ['apache2'],
  }

  # TODO: autogenerate ssl certificate
  exec { '/usr/sbin/a2enmod ssl' :
       unless => '/bin/readlink -e /etc/apache2/mods-enabled/ssl.load',
       notify => Service['apache2'],
       require => Package ['apache2'],
  }
}

# TODO: apache2::loadmodule restarts webserver with EVERY provision, even when nothing installs
# TODO: apache2::loadmodule doesn't seem to work
# https://snowulf.com/2012/04/05/puppet-quick-tip-enabling-an-apache-module/
# https://docs.puppetlabs.com/puppet/4.3/reference/lang_defined_types.html
define apache2::loadmodule () {
     exec { '/usr/sbin/a2enmod $name' :
          unless => '/bin/readlink -e /etc/apache2/mods-enabled/${name}.load',
          notify => Service['apache2'],
          require => Package ['apache2'],
     }
}