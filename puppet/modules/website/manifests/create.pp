# == Define: website::create
#
define website::create (
    $port,
    $live_url,
) {

  file { "${name}.dev.apache.conf":
    ensure  => 'present',
    name    => "/etc/apache2/sites-available/${name}.dev.apache.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('website/website.apache.conf.epp', {
      name        => $name,
      domain_name => $::vagrant_guest_domain,
      port        => $port,
      live_url    => $live_url,
    } ),
    require => Package['apache2'],
  }

  apache2::load_site{ "${name}.dev.apache":
    require => File["${name}.dev.apache.conf"],
  }

}
