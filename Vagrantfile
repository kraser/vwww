# -*- mode: ruby -*-
# vi: set ft=ruby :

# help from https://github.com/Varying-Vagrant-Vagrants/VVV
# more help from http://24ways.org/2014/what-is-vagrant-and-why-should-i-care/
# and https://github.com/Chassis/Chassis
# and https://coderwall.com/p/skazcg/avoid-syncing-wp-content-uploads
# https://github.com/gau1991/easyengine-vagrant
# https://github.com/videoMonkey/vagrant-lamp
# https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
# https://bitbucket.org/mmcmedia/asdika-web/commits/a91174541e0b4df286860ad699aec0640c52e9f0

vagrant_dir = File.expand_path(File.dirname(__FILE__))

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  cpus = 2
  memb = 1024

  # if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'parallels'
  # https://github.com/mitchellh/vagrant/issues/1867
  if defined? VagrantPlugins::Parallels
    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    config.vm.box = "parallels/ubuntu-14.04"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    config.vm.provider "parallels" do |prl|
      prl.name = "www"
      prl.linked_clone = true
      prl.update_guest_tools = false
      prl.memory = memb
      prl.cpus = cpus
    end
  else
    config.vm.box = "hashicorp/precise64"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", "{cpus}" ]
      vb.customize ["modifyvm", :id, "--memory", "{memb}"]
    end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  # vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  # defaults to the containing folder name
  # config.vm.hostname = "www-dev"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "../../sites", "/vagrant_www", owner: "www-data", group: "www-data"

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  config.vm.provision "file", source: "~/.bash_profile", destination: "~/.bash_profile"

  config.vm.provision :shell, path: "bootstrap.sh"

  ## Our symlinked Apache VirtualHost doesn't exist when apache is installed
  ## this ensures that the config file is picked up later
  # config.vm.provision "shell", inline: "service apache2 restart", run: "always"
  # config.vm.provision :shell, inline: "sudo service mysql restart", run: "always"
  # TODO: vagrant triggers to dump db

end
