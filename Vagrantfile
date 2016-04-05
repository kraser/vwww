# -*- mode: ruby -*-
# vi: set ft=ruby :

# help from:
# https://github.com/Varying-Vagrant-Vagrants/VVV
# http://24ways.org/2014/what-is-vagrant-and-why-should-i-care/
# https://github.com/Chassis/Chassis
# https://coderwall.com/p/skazcg/avoid-syncing-wp-content-uploads
# https://github.com/gau1991/easyengine-vagrant
# https://github.com/videoMonkey/vagrant-lamp
# https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
# https://bitbucket.org/mmcmedia/asdika-web/commits/a91174541e0b4df286860ad699aec0640c52e9f0
# https://gist.github.com/asmerkin/df919a6a79b081512366
# http://laravel-recipes.com/recipes/23/provisioning-vagrant-with-a-shell-script

# getting the hostname
require 'socket'
hostname = Socket.gethostname
hostname = hostname[/[\w|\d|\-|\_]+/] # only save the contents up to the first '.'

#setting SSH locale
ENV["LC_ALL"] = "en_US.UTF-8"

# few more things.
dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))
vagrant_name = File.basename(dir)
vagrant_version = Vagrant::VERSION.sub(/^v/, '')

# the potency of the VM
v_cpus = 2
v_memb = 1024


# and lets go!
Vagrant.configure(2) do |config|

  Vagrant.require_version ">= 1.8.0"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, ip: "192.168.10.3"
  config.vm.hostname = hostname + ".mmcmedia.org"
  # install vagrant ghost plugin `vagrant plugin install vagrant-ghost`
  # https://github.com/10up/vagrant-ghost
  config.ghost.hosts = [
    "home." + hostname + ".mmcmedia.org",
    "analytics." + hostname + ".mmcmedia.org"
  ]

  config.vm.provider :virtualbox do |vm|
    vm.customize ["modifyvm", :id, "--cpus", v_cpus ]
    vm.customize ["modifyvm", :id, "--memory", v_memb ]
    vm.name = vagrant_name
  end

  config.vm.provider :parallels do |vm, override|
    vm.memory = v_memb
    vm.cpus = v_cpus
    vm.name = vagrant_name
    vm.update_guest_tools = true
    override.vm.box = "parallels/ubuntu-14.04"
  end

  config.vm.provider :vmware_fusion do |vm, override|
    vm.vmx["memsize"] = v_memb
    vm.vmx["numvcpus"] = v_cpus
    override.vm.box = "netsensia/ubuntu-trusty64"
  end

  config.vm.provider :vmware_workstation do |vm, override|
    override.vm.box = "netsensia/ubuntu-trusty64"
  end

  config.vm.provider :hyperv do |vm, override|
    vm.memory = v_memb
    vm.cpus = v_cpus
    override.vm.box = "ericmann/trusty64"
  end

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 443, host: 443
  config.vm.network "forwarded_port", guest: 1234, host: 1234
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 8443, host: 8443

  # /srv/database/
  #
  # If a database directory exists in the same directory as your Vagrantfile,
  # a mapped directory inside the VM will be created that contains these files.
  # This directory is used to maintain default database scripts as well as backed
  # up mysql dumps (SQL files) that are to be imported automatically on vagrant up
  config.vm.synced_folder "database/", "/srv/database"

  # If the mysql_upgrade_info file from a previous persistent database mapping is detected,
  # we'll continue to map that directory as /var/lib/mysql inside the virtual machine. Once
  # this file is changed or removed, this mapping will no longer occur. A db_backup command
  # is now available inside the virtual machine to backup all databases for future use. This
  # command is automatically issued on halt, suspend, and destroy if the vagrant-triggers
  # plugin is installed.
  if File.exists?(File.join(vagrant_dir,'database/data/mysql_upgrade_info')) then
    if vagrant_version >= "1.3.0"
      config.vm.synced_folder "database/data/", "/var/lib/mysql", :mount_options => [ "dmode=777", "fmode=777" ]
    else
      config.vm.synced_folder "database/data/", "/var/lib/mysql", :extra => 'dmode=777,fmode=777'
    end

    # The Parallels Provider does not understand "dmode"/"fmode" in the "mount_options" as
    # those are specific to Virtualbox. The folder is therefore overridden with one that
    # uses corresponding Parallels mount options.
    config.vm.provider :parallels do |v, override|
      override.vm.synced_folder "database/data/", "/var/lib/mysql", :mount_options => []
    end
  end

  # /srv/log/
  #
  # If a log directory exists in the same directory as your Vagrantfile, a mapped
  # directory inside the VM will be created for some generated log files.
  config.vm.synced_folder "log/", "/srv/log", :owner => "www-data"


  # Customfile - POSSIBLY UNSTABLE
  #
  # Use this to insert your own (and possibly rewrite) Vagrant config lines. Helpful
  # for mapping additional drives. If a file 'Customfile' exists in the same directory
  # as this Vagrantfile, it will be evaluated as ruby inline as it loads.
  #
  # Note that if you find yourself using a Customfile for anything crazy or specifying
  # different provisioning, then you may want to consider a new Vagrantfile entirely.
  if File.exists?(File.join(vagrant_dir,'Customfile')) then
    eval(IO.read(File.join(vagrant_dir,'Customfile')), binding)
  end

  # Some boxes come with puppet installed, others don't
  # so here we quickly install it.
  config.vm.provision "shell", inline: <<-SHELL
    echo "checking for Puppet..."
    puppet=$(dpkg -s puppet | grep "install ok installed")
    if [[ -z $puppet ]]; then
      echo "Puppet not found. Installing Puppet for provisioning."
      sudo aptitude install --assume-yes puppet
    else
      echo "Puppet already installed, moving on"
    fi
  SHELL

  # Provisioning
  config.vm.provision :puppet do |puppet|
    # puppet.facter = {}
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "default.pp"
    puppet.options="--verbose"
  end

  # TODO: vagrant triggers dump db working
  if defined? VagrantPlugins::Triggers
    config.trigger.after :up, :stdout => true do
      run "vagrant ssh -c 'vagrant_up'"
    end
    config.trigger.before :reload, :stdout => true do
      run "vagrant ssh -c 'vagrant_halt'"
    end
    config.trigger.after :reload, :stdout => true do
      run "vagrant ssh -c 'vagrant_up'"
    end
    config.trigger.before :halt, :stdout => true do
      run "vagrant ssh -c 'vagrant_halt'"
    end
    config.trigger.before :suspend, :stdout => true do
      run "vagrant ssh -c 'vagrant_suspend'"
    end
    config.trigger.before :destroy, :stdout => true do
      run "vagrant ssh -c 'vagrant_destroy'"
    end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    # check cache size `du -h -d0 $HOME/.vagrant.d/cache`
  end

end
