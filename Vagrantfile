# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO: Setting env variables in guest
# TODO: check site names to make sure that they are safe

# Plugins Used
# https://github.com/10up/vagrant-ghost
# https://github.com/gosuri/vagrant-env

#setting SSH locale
ENV['LC_ALL'] = 'en_US.UTF-8'

# Import
require 'yaml'

# getting the names of things
dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))
vagrant_name = File.basename(dir)
# replacing invalid hostname characters with a valid one
vagrant_name = vagrant_name.gsub(/!\w|!d|!\-/, '-')

# and lets go!
Vagrant.configure(2) do |config|
  Vagrant.require_version ">= 1.8.0"
  # https://michaelheap.com/vagrant-require-installed-plugins/
  [
    { :name => "vagrant-env", :version => ">= 0.0.3" },
  ].each do |plugin|
    unless Vagrant.has_plugin?(plugin[:name], plugin[:version])
      raise "#{plugin[:name]} #{plugin[:version]} is required. Please run `vagrant plugin install #{plugin[:name]}`"
    end
  end
  [
    { :name => "vagrant-ghost", :version => ">= 0.2.1" },
    { :name => "vagrant-cachier", :version => ">= 1.2.1" },
    { :name => "vagrant-vbguest", :version => ">= 0.11.0" },
  ].each do |plugin|
    unless Vagrant.has_plugin?(plugin[:name], plugin[:version])
      warn "#{plugin[:name]} #{plugin[:version]} is recommended. Please run `vagrant plugin install #{plugin[:name]}`"
    end
  end

  # set ENV vars with a .env file
  config.env.enable

  # the potency of the VM
  v_cpus = (ENV['V_CPUS']) ? ENV['V_CPUS'] : 2
  v_memb = (ENV['V_MEMB']) ? ENV['V_MEMB'] : 1024

  v_apache_http = (ENV['APACHE_HTTP_PORT']) ? ENV['APACHE_HTTP_PORT'] : 8080
  v_apache_https = (ENV['APACHE_HTTPS_PORT']) ? ENV['APACHE_HTTPS_PORT'] : 8443

  config.vm.box = "ubuntu/trusty64"
  config.vm.network :private_network, ip: (ENV['VAGRANT_GUEST_IP']) ? ENV['VAGRANT_GUEST_IP'] : "192.168.12.3"
  config.vm.hostname = vagrant_name + '.' + ENV['VAGRANT_GUEST_DOMAIN']

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

  domains_array = ["#{vagrant_name}.dev"]
  ## WWW-APPS
  appsuite = '' # for some reason I have to pass in strings and arrayify them in puppet
  if File.exists?('conf/apps.yaml')
    apps = YAML.load_file('conf/apps.yaml')
    puts 'apps.yaml loaded.'
    apps.each do |app|
      domains_array.push("#{app["name"]}.#{ENV['VAGRANT_GUEST_DOMAIN']}")
      config.vm.synced_folder "#{app["local_path"]}", "/srv/www/appsuite-#{app["name"]}", owner: "root", group: "root"
      appsuite = "#{appsuite} #{app["name"]}"
    end
    config.vm.network 'forwarded_port', guest: v_apache_http, host: v_apache_http
    config.vm.network 'forwarded_port', guest: v_apache_https, host: v_apache_https
  else
    warn('No apps found. Did you create `conf/apps.yaml`?')
  end

  ## WWW-SITES
  websites = '' # for some reason I have to pass in strings and arrayify them in puppet
  if File.exists?('conf/sites.yaml')
    sites = YAML.load_file('conf/sites.yaml')
    puts 'sites.yaml loaded.'
    sites.each do |site|
      if site['port']
        config.vm.network 'forwarded_port', guest: site['port'], host: site['port']
      end
      config.vm.synced_folder "#{site["local_path"]}", "/srv/www/www-#{site["name"]}", owner: "root", group: "root"
      domains_array.push("#{site["name"]}.dev")
      websites = "#{websites} #{site["name"]},#{site["port"]},#{site["live_url"]}"
    end
  else
    warn('No websites found. Did you create `conf/sites.yaml`?')
  end

  ## WWW-OTHER
  # phpmyadmin
  if ENV['MYSQL_HOST'] && ENV['BRETANY_SALT']
    domains_array.push('phpmyadmin')
  end

  # SSH Agent Forwarding
  # Enable agent forwarding on vagrant ssh commands. This allows you to use ssh keys
  # on your host machine inside the guest. See the manual for `ssh-add`.
  config.ssh.forward_agent = true

  ## LOG
  # If a log directory exists in the same directory as your Vagrantfile, a mapped
  # directory inside the VM will be created for some generated log files.
  config.vm.synced_folder "log/", "/srv/log", :owner => "www-data"


  # Customfile - POSSIBLY UNSTABLE
  #
  # Use this to insert your own (and possibly rewrite) Vagrant config lines. Helpful
  # for mapping additional drives. If a file 'Customfile' exists in the same directory
  # as this Vagrantfile, it will be evaluated as ruby inline as it loads.
  if File.exists?(File.join(vagrant_dir,'Customfile')) then
    puts "Customfile loaded."
    eval(IO.read(File.join(vagrant_dir,'Customfile')), binding)
  end

  config.ghost.hosts = domains_array

  # adds a ~/.deliver/bin to the $PATH and a number of other shortcuts
  config.vm.provision "file", source: "Puppet/Files/bash_profile", destination: ".bash_profile"

  # TODO: enable ssl
  # APACHE SSLopenssl rsa -in server.key.org -out server.key
  # http://www.akadia.com/services/ssh_test_certificate.html
  # if File.exists?('conf/ssl/server.key') && File.exists?('conf/ssl/server.crt')
  #   puppet.facter.store('guestssl', true)
  # end

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

    puppet.facter = {
      "apache_http_port" => v_apache_http,
      "apache_https_port" => v_apache_https,
      "vagrant_guest_domain" => ENV['VAGRANT_GUEST_DOMAIN'],
      "logdir" => "/srv/log",
      "appsuite" => appsuite.strip,
      "websites" => websites.strip,
      "mysql_host" => ENV['MYSQL_HOST'],
      "bretany_salt" => ENV['BRETANY_SALT'],
    }
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "vwww.pp"
    puppet.options="--verbose"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    # check cache size `du -h -d0 $HOME/.vagrant.d/cache`
  end
end
