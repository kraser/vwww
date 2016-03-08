# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", "~/.composer/vendor/bin/" ] }

# One should make sure they have the latest packages before
# adding more
exec { "apt-update":
  command => 'aptitude update --quiet --assume-yes',
  # path => "/usr/bin", # unecessary after about trick.
}

# exec { "librarian-puppet":
#   command => 'gem install librarian-puppet',
#   require => Package['ruby1.9.1-dev'],
# }

package { "build-essential":
    ensure => latest
}

package { [
        "python-software-properties",
        "software-properties-common",
        "language-pack-en-base",
#        "ruby1.9.1-dev",
        "aptitude",
        "vim",
        "curl",
        "git",
        "ntp",
    ]:
    ensure => latest,
    require => Exec["apt-update"]
}



# class { 'git::install': }
# class { 'subversion::install': }
# class { 'apache2::install': }
# class { 'php5::install': }
# class { 'mysql::install': }
# class { 'wordpress::install': }
# class { 'phpmyadmin::install': }
# class { 'composer::install': }
# class { 'phpqa::install': }


# package { "curl":
#   ensure  => present,
#   # require => Exec["apt-get update"],
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
# node default {
#     include ntp
# }