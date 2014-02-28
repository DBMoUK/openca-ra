class { 'apache':
  default_vhost => false,
  docroot       => '/var/www/pki',
  docroot_owner => 'openca',
  docroot_group => 'openca',
  options       => ['-Indexes','-Multiviews','FollowSymLinks'],
  scriptaliases => {
    alias       => '/cgi-bin',
    path        => '/var/www/cgi-bin',
  },
  directories => [
    { path    => '/var/www', options => ['-Indexes','-Multiviews','FollowSymLinks']},
    { path    => '/var/www/cgi-bin', options => ['+ExecCGI','-Indexes','-Multiviews','+SymLinksIfOwnerMatch']}
  ],
}

apache::vhost { 'registration22.puppetlabs.vm':
  port          => '443',
  docroot       => '/var/www/pki',
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
