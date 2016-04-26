# == Define: apache2::load_module
define apache2::load_module () {
  exec { "/usr/sbin/a2enmod ${name}" :
    unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
    notify  => Service['apache2'],
    require => Package['apache2'],
  }
}
# https://snowulf.com/2012/04/05/puppet-quick-tip-enabling-an-apache-module/
