# One should make sure they have the latest packages before
# adding more
exec { "apt-update":
  command => 'aptitude update --quiet --assume-yes',
  path => "/usr/bin",
}

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", "~/.composer/vendor/bin/" ] }

# a few essential tools that make a server functional
package { [
    "python-software-properties",
    "software-properties-common",
    "language-pack-en-base",
    "build-essential",
    "vim",
    "curl",
    "git",
  ]:
  ensure => present,
  require => Exec["apt-update"]
}

# class { 'git::install': }
# class { 'subversion::install': }
class { 'apache2::install': }
class { 'php5::install': }
# class { 'mysql::install': }
# class { 'wordpress::install': }
# class { 'phpmyadmin::install': }
# class { 'composer::install': }
# class { 'phpqa::install': }

# LIBRARIAN-PUPPET
# I don't know that I need this or want this.
# package { 'ruby1.9.1-dev':
#   ensure   => 'installed',
#   require => Exec["apt-update"]
# }
# package { 'librarian-puppet':
#   ensure   => 'installed',
#   provider => 'gem',
#   require => Package["ruby1.9.1-dev"]
# }
