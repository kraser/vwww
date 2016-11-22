# Some basic configuration for our server
class init {

  # necessary for adding repos
  package { [
      'software-properties-common',
      'language-pack-en-base',
    ]:
    ensure => latest,
  }

  # this is the php that we want
  exec { 'ondrejphp_ppa':
    unless  => 'ls /etc/apt/sources.list.d | grep ondrej-php',
    command => 'add-apt-repository -y ppa:ondrej/php && apt-key update',
    require => Package['software-properties-common'],
  }

exec { 'git_ppa':
  unless  => 'ls /etc/apt/sources.list.d | grep git-core-ppa',
  command => 'add-apt-repository -y ppa:git-core/ppa && apt-key update',
  require => Package['software-properties-common'],
}

  # Set the Timezone to something useful
  exec { 'set_time_zone':
    unless  => 'more /etc/timezone | grep Madrid',
    command => 'echo "Europe/Madrid" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata',
  }

  # now let's update and get the latest packages
  exec { 'apt_update':
    command => 'aptitude update --quiet --assume-yes',
    require => Exec['ondrejphp_ppa', 'git_ppa'],
  }

  # and then get the other essentials
  package { [
      'python-software-properties',
      'build-essential',
      'puppet',
      'vim',
      'curl',
      'git',
    ]:
    ensure  => latest,
    require => Exec['apt_update'],
  }

  exec { 'clone_deliver':
    creates => '/home/vagrant/.deliver',
    command => 'git clone https://github.com/videoMonkey/deliver.git /home/vagrant/.deliver',
    require => Package['git']
  }
  # this command is linked in the bash_profile that is in this project
  #TODO: this needs to track with updates to deliver

}
