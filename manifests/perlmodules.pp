class openca::perlmodules {
  include perl

  perl::cpan::module { 'ExtUtils::MakeMaker':
    before => User['openca']
  }
  perl::cpan::module { 'MIME::Lite':
    before => User['openca'],
  }
  perl::cpan::module { 'Net::Server::Fork':
    before => Perl::Cpan::Module['XML::Twig'],
  }
  perl::cpan::module { 'MIME::Parser':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::Tools':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::Log::Message':
    before => User['openca'],
  }
  perl::cpan::module { 'XML::Twig':
    before  => User['openca'],
  }
  perl::cpan::module { 'XML::Parser':
    before => Perl::Cpan::Module['XML::Twig'],
  }
  perl::cpan::module { 'Net::SSLeay':
    before => User['openca'],
  }
  perl::cpan::module { 'Net::LDAP':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::TRIStateCGI':
    before => User['openca'],
  }
  perl::cpan::module { 'Parse::RecDescent':
    before => Perl::Cpan::Module['X500::DN']
  }
  perl::cpan::module { 'X500::DN':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::OpenSSL':
    before => Perl::Cpan::Module['X500::DN'],
  }
  perl::cpan::module { 'OpenCA::Crypto':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::REQ':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::CRR':
    before => User['openca'],
  }
  perl::cpan::module { 'OpenCA::CRL':
    before => User['openca'],
  }
  perl::cpan::module { 'ACME::PM::Voronezh':
    before => User['openca'],
  }
  perl::cpan::module { 'Convert::ASN1':
    before => User['openca'],
  }
  perl::cpan::module { 'Authen::SASL': 
    before => User['openca'],
  }
  perl::cpan::module { 'URI::ldap': 
    before => User['openca'],
  }
  perl::cpan::module { 'IO::Socket::SSL': 
    before => User['openca'],
  }
  perl::cpan::module { 'MIME::Base64': 
    before => User['openca'],
  }
  perl::cpan::module { 'XML::SAX::Writer': 
    before => User['openca'],
  }
}

# Install some missing, but required perl modules.
