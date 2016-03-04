class apache2::install {
  package { "apache2":
    ensure  => present,
    require => Exec["apt-get update"],
  }

  service { "apache2":
    ensure  => "running",
    require => Package["apache2"],
  }
}