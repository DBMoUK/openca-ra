class openca-ra::build {

  file { '/home/openca/build-opencatools.sh':
    ensure  => present,
    owner   => 'openca',
    group   => 'openca',
    source  => "puppet:///modules/openca-ra/build-opencatools.sh",
    before  => Exec['build-openca-tools'],
    require => User['openca'],
  }
  
  file { '/home/openca/build-opencabase.sh':
    owner   => 'openca',
    group   => 'openca',
    source  => "puppet:///modules/openca-ra/build-opencabase.sh",
    before  => Exec['build-openca'],
    require => User['openca'],
  }

  exec { 'build-openca-tools':
    provider => shell,
    command  => "bash -c 'cd /home/openca;
                 ./build-opencatools.sh'",
    require => Staging::Extract['openca-tools-1.3.0.tar.gz'],
    before  => Exec['build-openca'],
  }

  exec { 'build-openca':
    provider => shell,
    command  => "bash -c 'cd /home/openca;
                 ./build-opencabase.sh'",
    require => Staging::Extract['openca-base-1.5.0.tar.gz'],
    before  => Exec['set-ownership-apache-logs'],
  }
}
