# Vagrant-WWWW

If you want to use this currently you need to have installed [Vagrant](https://www.vagrantup.com) and [VirtualBox](http://www.virtualbox.org) but it should work with every provider that Vagrant supports.

The `Vagrantfile` can be overidden or further customized by including a file named `Customfile` beside it. It is ignored by git. See my [example](https://gist.github.com/videoMonkey/711aea775ebc86dee0f3)

**DO NOT MAKE SERVER CONFIGURATION CHANGES THROUGH SSH.** Update the appropriate puppet file and run `vagrant provision`. Ask me if you're confused about puppet.

## USAGE
To make this work you will need to create a file named `Customfile` it's kept out of version control. Here you will specify the synced directorys and port forwards necessary.

Example: (Do note whether or not your project has a public directory and configure accordingly)

```
config.vm.synced_folder "../site1/", "/srv/www/site1/", owner: "root", group: "root"
config.vm.network "forwarded_port", guest: 8001, host: 8001
```

Then you will need to create a file named `vhosts.conf` where you will define your apache virtual hosts.

Example:

```
Listen 8001
<VirtualHost *:8001>

  ErrorLog /srv/log/site1.error.log
  CustomLog /srv/log/site1.access.log combined

  # this example project has an html folder in it. your project might be all
  # public html, that would change the above folder sync to be:
  # config.vm.synced_folder "../site1/", "/srv/www/site1/html", owner: "root", group: "root"
  DocumentRoot "/srv/www/site1/html"
  ServerName site1.dev
  ServerAlias site1.*.xip.io
  <Directory "/srv/www/site1/html">
    Options Indexes MultiViews +FollowSymlinks
    AllowOverride All
    Order allow,deny
    Allow from all
  </Directory>
</VirtualHost>
```

Make sure these two files are present before you try to type `vagrant up` to launch the project.


