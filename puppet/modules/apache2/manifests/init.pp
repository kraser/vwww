# apache2
class apache2 {}

# TODO: autogenerate ssl certificate
# TODO: apache2::loadmodule doesn't seem to work
# https://snowulf.com/2012/04/05/puppet-quick-tip-enabling-an-apache-module/
# https://docs.puppetlabs.com/puppet/4.3/reference/lang_defined_types.html
# define apache2::loadmodule () {
#   exec { '/usr/sbin/a2enmod $name' :
#     unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
#     notify  => Service['apache2'],
#     require => Package ['apache2'],
# }
