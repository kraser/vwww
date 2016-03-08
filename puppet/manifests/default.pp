# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin", "~/.composer/vendor/bin/" ] }

# One should make sure they have the latest packages before
# adding more
exec { "apt-update":
  command => 'aptitude update --quiet --assume-yes',
  # path => "/usr/bin", # unecessary after about trick.
}

package { "build-essential":
    ensure => latest
}

package { [
        "python-software-properties",
        "software-properties-common",
        "language-pack-en-base",
        "ruby1.9.1-dev",
        "aptitude",
        "vim",
        "curl",
        "git",
        "ntp",
    ]:
    ensure => latest,
    require => Exec["apt-update"]
}

# exec { "librarian-puppet":
#   command => 'gem install librarian-puppet',
#   require => Package['ruby1.9.1-dev'],
# }

package { 'librarian-puppet':
  ensure   => 'installed',
  provider => 'gem',
  require => Package["ruby1.9.1-dev"]
}

exec { "ppa:ondrej/php5-5.6":
  command => 'add-apt-repository -y ppa:ondrej/php5-5.6',
  require => Package['software-properties-common'],
}

package { [
        "php5-mcrypt",
        "php5-redis",
        "php5-cli",
        "php5",
    ]:
    ensure => latest,
    require => Exec["apt-update", 'ppa:ondrej/php5-5.6']
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

service { "ntp":
  ensure  => "running",
  require => Package["ntp"],
}
# file { "/var/www/site1":
#   ensure  => "link",
#   target  => "/vagrant/site1",
#   require => Package["apache2"],
#   notify  => Service["apache2"],
# }
# node default {
#     include ntp
# }