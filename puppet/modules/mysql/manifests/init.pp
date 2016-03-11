class mysql::install($root_password) {
    package { [
            "mysql-server",
            "mysql-client",
            "libmysqlclient-dev",
            "libapache2-mod-auth-mysql",
        ]:
        ensure => latest
    }

    file { "/etc/mysql/my.cnf":
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => 644,
        source => "puppet:///modules/mysql/my.cnf",
        require => Package["mysql-server"],
        notify => Service["mysql"]
    }

    # TODO: set root user to wildcard access
    exec { "set-root-password":
        subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p${root_password} status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password ${root_password}",
    }

    service { "mysql":
        require => [ Package["mysql-server"], Exec["set-root-password"] ],
        hasstatus => true,
        hasrestart => true,
    }
}