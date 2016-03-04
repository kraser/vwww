# Vagrant-WWWW

If you want to use this currently you need to have installed [Vagrant](https://www.vagrantup.com) and [VirtualBox](http://www.virtualbox.org) but it should work with every provider that Vagrant supports.

The `Vagrantfile` can be overidden or further customized by including a file named `Customfile` beside it. It is ignored by git.

**DO NOT MAKE SERVER CONFIGURATION CHANGES THROUGH SSH.** Update the appropriate puppet file and run `vagrant provision`. Ask me if you're confused about puppet.

You can build the puppet stuff (which requires [puppet](https://docs.puppetlabs.com) and librarian-puppet(http://librarian-puppet.com/)) from the vagrant machine, or you can install those tools on your local computer.