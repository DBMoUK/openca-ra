class { 'apache':
  default_vhost => false,
}

apache::vhost { 'registration.puppetlabs.vm':
  port          => '443',
  docroot       => '/var/www/html/pki',
  ssl           => true,
  docroot_owner => 'openca',
  docroot_group => 'openca',
  options       => ['-Indexes','-Multiviews','FollowSymLinks'],
  scriptaliases => {
    alias       => '/cgi-bin/',
    path        => '/var/www/cgi-bin',
  },
  directories => [
    { path    => '/var/www', options => ['-Indexes','-Multiviews','FollowSymLinks']},
    { path    => '/var/www/cgi-bin', options => ['+ExecCGI','-Indexes','-MultiViews','+SymLinksIfOwnerMatch']}
    ],
}
