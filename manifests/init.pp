# == Class: openca
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
  include openca::ext_modules
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
    source => 'puppet:///modules/openca/openca.sh',
    before => Service['openca'], 
  }

  file { '/etc/httpd/conf/vhost.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('openca/vhost.conf.erb'),
    notify  => Service['httpd'],
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
    source  => 'puppet:///modules/openca/config.xml',
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
    command  => "bash -c 'cd /opt/openca/etc/openca; 
                 ./configure_etc.sh'",
    before   => Service['openca'], 
    require  => Exec['build-openca'],
  }
 
  service { 'openca':
    path       => '/etc/init.d/openca.sh',
    start      => '/etc/init.d/openca.sh start',
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
  }

}
