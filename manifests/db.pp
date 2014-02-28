class openca::db {

  #  file { '/etc/my.cnf':
  # ensure => file,
  #  content => template('openca/my.cnf.erb'),
  #  before => Exec['/usr/bin/mysql_install_db'],
  #}
  exec { '/usr/bin/mysql_install_db':
    provider => shell,
    command  => "bash -c '/usr/bin/mysql_install_db'",
    require  => Package['mysql-server'],
    before   => Service['mysqld']
  }
 
}
