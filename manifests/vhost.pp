class openca-ra::vhost {
  include apache

  file { '/var/www/html':
    ensure  => directory,
    owner   => 'openca',
    group   => 'openca',
    require => User['openca'],
  }
}
