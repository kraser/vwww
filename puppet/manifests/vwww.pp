# TODO: set apache logging to /srv/log
# TODO: set php logging to /srv/log
# TODO: autogenerate ssl certificate

# puppet style guide: https://docs.puppet.com/guides/style_guide.html
# Puppet linter:      http://puppet-lint.com/checks/

# set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/',
  '/usr/local/bin', '/usr/local/sbin', '~/.composer/vendor/bin/' ] }

# setting the stage
stage { 'opening_act': before => Stage['main'], }
stage { 'encore': require => Stage['main'], }

# class { 'motdtest': stage => opening_act }
class { 'init': stage => opening_act }
class { 'apache2::install': stage => main }
class { 'php5::install': stage => main }
class { 'phpmyadmin::install': stage => main }

notice($appsuite)
notice($websites)

# these are passed in from the puppet.facter line in the vagrantfile
# each($appsuite) |$app| { notice($app) }
each($appsuite) |$app| { webapp::create{ $app : } }
# each($websites) |$site| { notice($site) }
