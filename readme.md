# Vagrant-WWW

[PHPMYADMIN](http://localhost:1234/phpmyadmin) | [PHPINFO](http://localhost/)

If you want to use this currently you need to have installed [Vagrant](https://www.vagrantup.com) and [VirtualBox](http://www.virtualbox.org) but it should work with every provider that Vagrant supports.

The `Vagrantfile` can be overidden or further customized by including a file named `Customfile` beside it. It is ignored by git. See my [example](https://gist.github.com/videoMonkey/711aea775ebc86dee0f3).

**DO NOT MAKE SERVER CONFIGURATION CHANGES THROUGH SSH.** Update the appropriate puppet file and run `vagrant provision`. Ask me if you're confused about puppet.

## USAGE
To make this work you will need to create a file named:
- `.env` ([example](https://gist.github.com/videoMonkey/))
- `conf/apps.yaml` ([example](https://gist.github.com/videoMonkey/))
- and optionally `conf/sites.yaml` ([example](https://gist.github.com/videoMonkey/))

You also need to install `vagrant-ghost` and `vagrant-env`.

Make sure these files are present before you try to type `vagrant up` to launch the project.

Your sites are mapped name.dev

this depends on their being a mysql server installed on the host with an environment variable set in `.env`
