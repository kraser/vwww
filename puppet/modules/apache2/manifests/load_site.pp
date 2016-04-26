# == Define: apache2::load_site
define apache2::load_site () {
  exec { "/usr/sbin/a2ensite ${name}" :
    unless  => "/bin/readlink -e /etc/apache2/sites-enabled/${name}.conf",
    notify  => Service['apache2'],
    require => Package['apache2'],
  }
}
