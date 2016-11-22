# TODO: autogenerate ssl certificate
# TODO: autogenerate a welcome page highlighting hosted sites
# TODO: error check for website without live_url

# puppet style guide: https://docs.puppet.com/guides/style_guide.html
# Puppet linter:      http://puppet-lint.com/checks/

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
  '/usr/local/bin', '/usr/local/sbin', '~/.composer/vendor/bin/' ] }

# setting the stage
stage { 'opening_act': before => Stage['main'], }
stage { 'encore': require => Stage['main'], }

# make vwww
class { 'init': stage => opening_act }
class { 'apache2::install': stage => main }
class { 'apache2::ssl': stage => main }
class { 'php5::install': stage => main }
class { 'nodejs::install': stage => main }
# TODO: empty $:: variable are causing warnings in the output,
# I would like to figure out how to stop that...

# these are passed in from the puppet.facter line in the vagrantfile
$www_apps = split($::appsuite, ' ')
$www_sites = split($::websites, ' ')
$sites = split($::vwww, ' ')

each($www_apps) |$app| { webapp::create{ $app: } }
each($www_sites) |$site| {
  $www = split($site, ',')
  website::create{ $www[0]:
    port     => $www[1],
    live_url => $www[2],
  }
}

each($sites) |$site| {
  $www = split($site, ',')
  vwww::create{ $www[0]:
    port        => $www[1],
    live_url    => $www[2],
    public_html => $www[3],
  }
}
