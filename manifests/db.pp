class openca::db {

  exec { '/usr/bin/mysql_install_db':
    provider => shell,
    command  => "bash -c '/usr/bin/mysql_install_db'",
    require  => Package['mysql-server'],
    before   => Service['mysqld']
  }
 
}
  # Install MySQL Database for OpenCA.
