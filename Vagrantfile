# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO: Setting env variables in guest
# TODO: passing sites and apps into facter

# Plugins Used
# https://github.com/10up/vagrant-ghost
# https://github.com/gosuri/vagrant-env

#setting SSH locale
ENV["LC_ALL"] = "en_US.UTF-8"

require 'yaml'
require 'socket'

# getting the names of things
dir = Dir.pwd
hostname = Socket.gethostname
hostname = hostname[/[\w|\d|\-]+/] # only save the contents up to the first '.'
vagrant_dir = File.expand_path(File.dirname(__FILE__))
vagrant_name = File.basename(dir)
vagrant_name = vagrant_name.gsub(/!\w|!d|!\-/, '-')
vagrant_version = Vagrant::VERSION.sub(/^v/, '')
vagrant_name = hostname + '-' + vagrant_name

# the potency of the VM
v_cpus = 2
v_memb = 1024

# and lets go!
Vagrant.configure(2) do |config|

  # set ENV vars with a .env file
  config.env.enable

  Vagrant.require_version ">= 1.8.0"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, ip: ENV['VAGRANT_GUEST_IP']
  config.vm.hostname = vagrant_name + '.' + ENV['VAGRANT_GUEST_TLD']


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

  ## WWW-APPS
  domains_array = []
  apps = YAML.load_file('conf/apps.yaml')
  apps.each do |app|
    domains_array.push("#{app["name"]}.#{ENV['VAGRANT_GUEST_TLD']}")
    config.vm.synced_folder "#{app["local_path"]}", "/srv/www/appsuite-#{app["name"]}", owner: "root", group: "root"
  end
  config.vm.network "forwarded_port", guest: 80, host: 80
  # config.vm.network "forwarded_port", guest: 443, host: 443
  # config.vm.network "forwarded_port", guest: 8080, host: 8080
  # config.vm.network "forwarded_port", guest: 8443, host: 8443

  ## WWW-SITES
  if sites = YAML.load_file('conf/sites.yaml')
    sites.each do |site|
      config.vm.network "forwarded_port", guest: site['port'], host: site['port']
      config.vm.synced_folder "#{site["local_path"]}", "/srv/www/www-#{site["name"]}", owner: "root", group: "root"
      domains_array.push("#{site["name"]}.dev")
    end
  end


  ## WWW-OTHER
  # phpmyadmin
  config.vm.network "forwarded_port", guest: 1234, host: 1234
  # livereload
  # config.vm.network "forwarded_port", guest: 35729, host: 35729

  ## LOG
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

  config.ghost.hosts = domains_array

  # Some boxes come with puppet installed, others don't
  # so here we quickly install it.
  config.vm.provision "shell", inline: <<-SHELL
    echo "Checking Puppet version..."
    puppet=$(dpkg -s puppet | grep "Version: 3.8")
    if [[ -z $puppet ]]; then
      echo "Puppet either missing or not up-to-data."
      echo "Installing/updating puppet"
      cd ~ && wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
      sudo dpkg -i puppetlabs-release-trusty.deb
      sudo aptitude update
      sudo aptitude install --assume-yes puppet
    else
      echo "Puppet already installed and up to date, moving on"
    fi
    echo "Provisioning puppet.conf"
    sudo cp /vagrant/puppet/files/puppet.conf /etc/puppet/puppet.conf
    sudo service puppet restart
  SHELL


  # Provisioning
  config.vm.provision :puppet do |puppet|
    puppet.facter = { "logdir" => "/srv/log" }
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "www.pp"
    puppet.options="--verbose"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    # check cache size `du -h -d0 $HOME/.vagrant.d/cache`
  end
end
