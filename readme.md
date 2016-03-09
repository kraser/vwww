# Vagrant-WWWW

If you want to use this currently you need to have installed [Vagrant](https://www.vagrantup.com) and [VirtualBox](http://www.virtualbox.org) but it should work with every provider that Vagrant supports.

The `Vagrantfile` can be overidden or further customized by including a file named `Customfile` beside it. It is ignored by git. See my [example](https://gist.github.com/videoMonkey/711aea775ebc86dee0f3)

**DO NOT MAKE SERVER CONFIGURATION CHANGES THROUGH SSH.** Update the appropriate puppet file and run `vagrant provision`. Ask me if you're confused about puppet.
