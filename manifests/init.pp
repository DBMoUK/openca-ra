# == Class: openca-ra
#
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
#  class { openca-ra:
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
class openca-ra {
  include stdlib
  include openca-ra::vhost
  include openca-ra::install
  include openca-ra::db
  include openca-ra::build
  include mysql::server

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
  
  user { 'openca':
    ensure     => present,
    groups     => 'openca',
    managehome => true,
  }

  group { 'openca':
    ensure => present,
  }

  user { 'madwolf':
    ensure => present,
    groups => 'madwolf',
  }

  group { 'madwolf':
    ensure => present,
  }

  file { '/etc/init.d/openca.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/openca-ra/openca.sh',
    before => Service['openca'], 
  }

  exec { 'set-ownership-apache-logs':
    provider => shell,
    command  => "bash -c 'chown -R apache:apache /opt/openca/var/openca/log'",
    before   => File['/opt/openca/etc/openca/config.xml'],
  }

  file { '/opt/openca/etc/openca/config.xml':
    ensure  => file,
    owner   => 'openca',
    group   => 'openca',
    source  => 'puppet:///modules/openca-ra/config.xml',
    before  => File['/var/www/cgi-binpki'],
    require => User['openca'],
  }

  file { '/var/www/cgi-binpki':
    ensure => link,
    target => '/var/www/cgi-bin/pki',
    before => Service['openca'],
  }
  exec {'setup-openca-config':
    provider => shell,
    command  => "bash -c 'cd /opt/openca/etc/openca; ./configure_etc.sh'",
    before   => Service['openca'], 
  }
 
  service { 'openca':
    path       => '/etc/init.d/openca.sh',
    start      => '/etc/init.d/openca.sh start',
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

 file { '/opt/openca/etc/openca/':
   ensure  => present, 
   mode    => '0750',
   owner   => 'openca',
   group   => 'apache',
   recurse => true,
   before  => Service['openca'],
 }  
}
