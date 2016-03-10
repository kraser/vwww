class apache2::install {
  package { "apache2":
    ensure  => latest,
    require => Exec["apt-update"],
  }

  service { "apache2":
    ensure  => "running",
    require => [
      Package["apache2"],
      File["/etc/apache2/apache2.conf"],
    ]
  }

  file { "/etc/apache2/apache2.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 644,
    source => "puppet:///modules/apache2/apache2.conf",
    require => Package["apache2"],
    notify => Service["apache2"],
  }
}

# define apache2::loadmodule () {
#      exec { "/usr/sbin/a2enmod $name" :
#           unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
#           notify => Service[apache2]
#      }
# }