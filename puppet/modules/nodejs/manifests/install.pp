# setup and install nodejs along with some pacakges
class nodejs::install {

  exec { 'node_ppa':
    unless  => 'ls /etc/apt/sources.list.d | grep nodesource.list',
    command => 'curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && apt-key update',
    require => Package['software-properties-common', 'build-essential'],
  }

  package { 'nodejs':
    ensure  => latest,
    require => Exec['node_ppa', 'apt_update'],
  }

  file { '/usr/bin/node':
    ensure  => 'link',
    target  => '/usr/bin/nodejs',
    require => Package['nodejs']
  }

  exec { 'install_bower':
    unless  => 'which bower',
    command => 'npm install -g bower',
    require => Package['nodejs'],
  }

  exec { 'install_gulp':
    unless  => 'which gulp',
    command => 'npm install -g gulp-cli',
    require => Package['nodejs'],
  }

  exec { 'install_grunt':
    unless  => 'which grunt',
    command => 'npm install -g grunt-cli',
    require => Package['nodejs'],
  }
}
