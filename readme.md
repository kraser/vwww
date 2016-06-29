# VWWW

## yet another vagrant based webserver

This one offers:

- painless addition of sites, just add it to apps.yaml or sites.yaml and run `vagrant reload --provision`
- sites work with [xip.io](http://xip.io)!

## getting started

1. install [VirtualBox](http://www.virtualbox.org) (or any other vagrant supporter provider like vmware or hyper-v)
2. install [Vagrant](https://www.vagrantup.com)
3. install `vagrant-ghost`
4. install `vagrant-env`
5. create a `.env` file at the root of this project. this file must include settings for `VAGRANT_GUEST_IP="192.168.12.3"` and `VAGRANT_GUEST_DOMAIN="example.com"`, they are used for creating the apache configs
6. add apps to `conf/apps.yaml` ([example](https://gist.github.com/videoMonkey/1b2a2bc4548c51f2f18b76b8d38e8c0b))
7. and optionally add sites to `conf/sites.yaml` ([example](https://gist.github.com/videoMonkey/3c08735d8718f37eab25408cf2ccb336))
8. run `vagrant up`

You should eventually be able to go to [vwww.dev:8080](http://vwww.dev:8080) and see that it's all working.

## Customization

The `Vagrantfile` can be overidden or further customized by including a file named `Customfile` beside it, `Customfile` is ignored by git.

The server itself is controlled by puppet. **DO NOT MAKE SERVER CONFIGURATION CHANGES THROUGH SSH.** Update the appropriate puppet file and run `vagrant provision`. Ask me if you're confused about puppet.

Apache ports can be customized to be anything you want in the `.env` file by setting `APACHE_HTTP_PORT="80"` and `APACHE_HTTPS_PORT="443"`

## linting

managed by npm and requires that `puppet-lint` be in your path (hint: `gem install puppet-lint`) as well as `ruby`. lint running `npm test`.

## SSH

SSH forwarding means that you can use this virtual machine just like you would your local machine, but to make it work you need to make sure that `ssh-agent` is running. Help from [GitHub](https://help.github.com/articles/working-with-ssh-key-passphrases/). 

## sites v. apps

There are two main differences between sites and apps. The most important of which is that sites are linked at `site/html` and can't have any source above that. Apps are expected to have an html folder in them.

The domains and ports your sites are mapped to can be read from the output of `vagrant up`.
