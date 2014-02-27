class openca-ra::install {
  include staging

  $curl_option = "--insecure"

  file { '/home/openca':
    ensure  => directory,
    owner   => 'openca',
    group   => 'openca',
    require => User['openca'],
    before  => Exec['build-openca-tools'],
  }

  file { '/downloads':
    ensure => directory,
  }

  staging::file { 'openca-base-1.5.0.tar.gz':
    curl_option => $curl_option,
    source      => 'https://pki.openca.org/cgi-bin/download?target=openca-base-1.5.0.tar.gz',
    target      => '/home/openca/openca-base-1.5.0.tar.gz',
    require     => File['/home/openca']
  }

  staging::file { 'openca-tools-1.3.0.tar.gz':
    curl_option => $curl_option,
    source      => 'https://pki.openca.org/cgi-bin/download?target=openca-tools-1.3.0.tar.gz',
    target      => '/home/openca/openca-tools-1.3.0.tar.gz',
    require     => File['/home/openca'] 
  }

  staging::extract { 'openca-base-1.5.0.tar.gz':
    source  => '/home/openca/openca-base-1.5.0.tar.gz',
    target  => '/home/openca/',
    creates => '/home/openca/openca-base-1.5.0',
    user    => 'openca',
    group   => 'openca',
    require => Staging::File['openca-base-1.5.0.tar.gz'],
  }

  staging::extract { 'openca-tools-1.3.0.tar.gz':
    source  => '/home/openca/openca-tools-1.3.0.tar.gz',
    target  => '/home/openca',
    creates => '/home/openca/openca-tools-1.3.0',
    user    => 'openca',
    group   => 'openca',
    require => Staging::File['openca-tools-1.3.0.tar.gz'],
  }
}

