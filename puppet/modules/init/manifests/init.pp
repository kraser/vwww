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
  exec { 'ondrejppa_php56':
    unless  => 'ls /etc/apt/sources.list.d | grep ondrej-php5-5_6',
    command => 'add-apt-repository -y ppa:ondrej/php5-5.6 && apt-key update',
    require => Package['software-properties-common'],
  }

  # Set the Timezone to something useful
  exec { 'set_time_zone':
    unless  => 'more /etc/timezone | grep Madrid',
    command => 'echo "Europe/Madrid" | sudo tee /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata',
  }

  # now let's update and get the latest packages
  exec { 'apt-update':
    command => 'aptitude update --quiet --assume-yes',
    require => Exec['ondrejppa_php56'],
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
    require => Exec['apt-update'],
  }
}
