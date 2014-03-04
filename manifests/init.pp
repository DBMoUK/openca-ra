# == Class: openca
# Sets up Registration Authority Node for OpenCA.
#
# === Parameters
#
#
# === Variables
#
#
# === Examples
#
#  class { openca:
#  }
#
# === Authors
#
# Author David Bryant-Moore <david.bmoore@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 David Bryant-Moore, unless otherwise noted.
#
class openca {
  include stdlib
  include openca::vhost
  include openca::install
  include openca::db
  include openca::build
  include mysql::server

  # Include required classes.

  ensure_packages(
    [
     'make',
     'unzip',
     'links',
     'ftp',
     'gnupg2',
     'gcc',
     'openssl',
     'openssl-devel',
     'db4-devel',
     'expat-devel',
     'mod_ssl',
     'perl-devel',
     'mysql',
     'mysql-server',
     'mysql-devel',
     'php-mysql'
    ]
  )

  # Ensure required packages are present.

  user { 'openca':
    ensure     => present,
    groups     => 'openca',
    managehome => true,
  }

  # Manage openca user, ensure perl modules get installed first.

  group { 'openca':
    ensure => present,
  }

  # Manage openca group.

  file { '/etc/init.d/openca.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/openca/openca.sh',
    before => Service['openca'],
  }

  # Manage openca init script.

  file { '/etc/httpd/conf/vhost.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('openca/vhost.conf.erb'),
    require => Service['httpd'],
  }

  # Manage virtual host for Apache to serve OpenCA.

  exec { 'set-ownership-apache-logs':
    provider => shell,
    command  => "bash -c 'chown -R apache:apache /opt/openca/var/openca/log'",
    before   => File['/opt/openca/etc/openca/config.xml'],
  }

  # Set ownership on Apache logs in OpenCA directory tree.

  file { '/opt/openca/etc/openca/config.xml':
    ensure  => file,
    owner   => 'openca',
    group   => 'openca',
    source  => 'puppet:///modules/openca/config.xml',
    before  => File['/var/www/cgi-binpki'],
    require => User['openca'],
  }

  # Manage OpenCA config.xml file with baked settings.

  file { '/var/www/cgi-binpki':
    ensure => link,
    target => '/var/www/cgi-bin/pki',
    before => Service['openca'],
  }

  # Manage symlink for cgi-bin due to bug in OpenCA.

  exec {'setup-openca-config':
    provider => shell,
    command  => "bash -c 'cd /opt/openca/etc/openca;
                 ./configure_etc.sh'",
    before   => Service['openca'],
    require  => Exec['build-openca'],
  }

  # Manage OpenCA configure script after OpenCA has built.

  service { 'openca':
    path       => '/etc/init.d/openca.sh',
    start      => '/etc/init.d/openca.sh start',
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

  # Manage OpenCA service.

}
