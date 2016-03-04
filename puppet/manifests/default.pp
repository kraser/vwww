exec { "apt-get update":
  command => 'apt-get update',
  path => "/usr/bin",
}

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", "~/.composer/vendor/bin/" ] }

# class { 'git::install': }
# class { 'subversion::install': }
class { 'apache2::install': }
class { 'php5::install': }
# class { 'mysql::install': }
# class { 'wordpress::install': }
# class { 'phpmyadmin::install': }
# class { 'composer::install': }
# class { 'phpqa::install': }


# package { "apache2":
#   ensure  => present,
#   require => Exec["apt-get update"],
# }

# package { 'git':
#   ensure => present,
# }

# service { "apache2":
#   ensure  => "running",
#   require => Package["apache2"],
# }
# file { "/var/www/site1":
#   ensure  => "link",
#   target  => "/vagrant/site1",
#   require => Package["apache2"],
#   notify  => Service["apache2"],
# }