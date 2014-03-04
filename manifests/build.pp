class openca::build {

  file { '/home/openca/build-opencatools.sh':
    ensure  => present,
    owner   => 'openca',
    group   => 'openca',
    source  => "puppet:///modules/openca/build-opencatools.sh",
    before  => Exec['build-openca-tools'],
    require => User['openca'],
  }
 
  # Manage shell script to build OpenCA tools.

  file { '/home/openca/build-opencabase.sh':
    owner   => 'openca',
    group   => 'openca',
    source  => "puppet:///modules/openca/build-opencabase.sh",
    before  => Exec['build-openca'],
    require => User['openca'],
  }

  # Manage shell script to build OpenCA base.

  exec { 'build-openca-tools':
    provider => shell,
    command  => "bash -c 'cd /home/openca;
                 ./build-opencatools.sh'",
    require => Staging::Extract['openca-tools-1.3.0.tar.gz'],
    before  => Exec['build-openca'],
  }
 
  # Build OpenCA tools.

  exec { 'build-openca':
    provider => shell,
    command  => "bash -c 'cd /home/openca;
                 ./build-opencabase.sh'",
    require  => Exec['build-openca-tools'],
    before   => Exec['set-ownership-apache-logs'],
  }

  # Build OpenCA Base.


  }
