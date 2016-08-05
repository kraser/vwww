# == Define: vwww::create
#
define vwww::create (
    $port,
    $live_url,
    $public_html,
) {

  file { "${name}.apache.conf":
    ensure  => 'present',
    name    => "/etc/apache2/sites-available/${name}.apache.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('vwww/vwww.apache.conf.epp', {
      name        => $name,
      port        => $port,
      live_url    => $live_url,
      public_html => $public_html,
    } ),
    require => Package['apache2'],
  }

  apache2::load_site{ "${name}.apache":
    require => File["${name}.apache.conf"],
  }

}
