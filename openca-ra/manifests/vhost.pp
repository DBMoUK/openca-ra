class openca-ra::vhost {
  include apache

  file { '/var/www/html':
    ensure  => present,
    owner   => 'openca',
    group   => 'openca',
    require => User['openca'],
  }
}
