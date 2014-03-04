class openca::install {
  include staging

  # Include staging class.

  $curl_option = "--insecure"

  # Downloading collateral over https: curl => insecure due to dodgy cert.

  file { '/home/openca':
    ensure  => directory,
    owner   => 'openca',
    group   => 'openca',
    require => User['openca'],
    before  => Exec['build-perl-modules'],
  }

  file { '/home/openca/OpenCA_Perl_Modules.tar.gz':
    ensure  => file,
    owner   => 'openca',
    source  => 'puppet:///modules/openca/OpenCA_Perl_Modules.tar.gz',
    require => File['/home/openca'],
    before  => Staging::Extract['/home/openca/OpenCA_Perl_Modules.tar.gz'],
  }

  staging::extract{ '/home/openca/OpenCA_Perl_Modules.tar.gz':
    source  => '/home/openca/OpenCA_Perl_Modules.tar.gz',
    target  => '/home/openca',
    creates => '/home/openca/OPENCA_PERL_MODULES',
    before  => File['/opt/openca/ca/modules/perl5/lib/perl5'],
    require => File['/home/openca/OpenCA_Perl_Modules.tar.gz'],
  }

  file { 
    ['/opt',
     '/opt/openca/',
     '/opt/openca/ca',
     '/opt/openca/ca/modules/',
     '/opt/openca/ca/modules/perl5',
     '/opt/openca/ca/modules/perl5/lib',
     '/opt/openca/ca/modules/perl5/lib/perl5']:
    
    ensure  => directory,
    owner   => 'openca',
    before  => Exec['build-perl-modules'],
    require => Staging::Extract['/home/openca/OpenCA_Perl_Modules.tar.gz'],
  }

  file { '/home/openca/build_perl_modules.sh':
    owner   => 'openca',
    group   => 'openca',
    require => File['/home/openca'],
    before  => Exec['build-perl-modules'],
    source  => 'puppet:///modules/openca/build_perl_modules.sh',
  }

  exec { 'build-perl-modules':
    provider => shell,
    command  => "bash -c 'cd /home/openca/; ./build_perl_modules.sh'",
    require  => File['/opt/openca/ca/modules/perl5/lib/perl5'],
    before   => Exec['build-openca']
  }

  # Manage OpenCA user home directory.

  file { '/downloads':
    ensure => directory,
  }

  # Manage downloads directory for collateral.

  staging::file { 'openca-base-1.5.0.tar.gz':
    curl_option => $curl_option,
    source      => 'https://pki.openca.org/cgi-bin/download?target=openca-base-1.5.0.tar.gz',
    target      => '/home/openca/openca-base-1.5.0.tar.gz',
    require     => File['/home/openca']
  }

  # Download OpenCA base distribution.

  staging::file { 'openca-tools-1.3.0.tar.gz':
    curl_option => $curl_option,
    source      => 'https://pki.openca.org/cgi-bin/download?target=openca-tools-1.3.0.tar.gz',
    target      => '/home/openca/openca-tools-1.3.0.tar.gz',
    require     => File['/home/openca'] 
  }

  # Download OpenCA tools distribution.

  staging::extract { 'openca-base-1.5.0.tar.gz':
    source  => '/home/openca/openca-base-1.5.0.tar.gz',
    target  => '/home/openca/',
    creates => '/home/openca/openca-base-1.5.0',
    user    => 'openca',
    group   => 'openca',
    require => Staging::File['openca-base-1.5.0.tar.gz'],
  }

  # Extract OpenCA base distribution in /home/openca

  staging::extract { 'openca-tools-1.3.0.tar.gz':
    source  => '/home/openca/openca-tools-1.3.0.tar.gz',
    target  => '/home/openca',
    creates => '/home/openca/openca-tools-1.3.0',
    user    => 'openca',
    group   => 'openca',
    require => Staging::File['openca-tools-1.3.0.tar.gz'],
  }
}
  # Extract OpenCA tools distribution in /home/openca
