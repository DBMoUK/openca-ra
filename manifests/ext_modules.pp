class openca::ext_modules {

  # Setup external Perl modules for OpenCA.

  $openca_ext_modules = '/home/openca/openca-base-1.5.0/src/ext-modules'

  file { "${openca_ext_modules}/XML-Twig-3.39.tar.gz":
    ensure  => absent,
    require => Staging::Extract['openca-base-1.5.0.tar.gz'],
  }

  file { "${openca_ext_modules}/XML-Twig-3.44.tar.gz":
    ensure  => file,
    owner   => 'openca',
    group   => 'openca',
    source  => 'puppet:///modules/openca/XML-Twig-3.44.tar.gz',
    require => Staging::Extract['openca-base-1.5.0.tar.gz'], 
  }

}
