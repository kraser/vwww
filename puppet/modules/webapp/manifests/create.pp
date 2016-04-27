# == Define: webapp::create
#
define webapp::create () {
  # the user for the app
  user { "appsuite-${name}":
    ensure     => 'present',
    managehome => true,
    # password is 'test'
    password   => '$6$lY2Gp3Cr$zNrUB7T3yibUF/gWn5cTQ0fNv7MUmx/DZuw3E7I..Vh9tITG28BtgvXJPU4Gm4Z/9oNvlbX24KzQ9Ib1QH1B9.',
    shell      => '/bin/bash',
  }

  file { "${name}.apache.conf":
    ensure  => 'present',
    name    => "/etc/apache2/sites-available/${name}.apache.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('webapp/webapp.apache.conf.epp', {
      name   => $name,
      domain => $::vagrant_guest_domain,
      logdir => $::logdir,
    } ),
    require => Package['apache2'],
  }

  file { "/home/appsuite-${name}/app":
    ensure  => 'link',
    target  => "/srv/www/appsuite-${name}",
    require => User["appsuite-${name}"],
  }

  apache2::load_site{ "${name}.apache":
    require => File["${name}.apache.conf"],
  }

}
