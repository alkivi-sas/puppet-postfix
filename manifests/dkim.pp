class postfix::dkim (
  $dns_servers      = ['ns102.ovh.net', 'dns102.ovh.net'],
  $canonicalization = 'relaxed/relaxed',
  $keyTable         = '/etc/opendkim/KeyTable',
  $trustedHost      = '/etc/opendkim/TrustedHosts',
  $signingTable     = '/etc/opendkim/SigningTable',
  $configFile       = '/etc/opendkim.conf',
) {

  validate_string($hostname)

  $packages     = ['opendkim', 'opendkim-tools']
  $service      = 'opendkim'

  File {
    ensure  => present,
    owner   => 'opendkim',
    group   => 'opendkim',
    mode    => '0644',
    notify  => Service[$service],
    require => Package[$packages],
  }

  Package {
    ensure => installed,
  }

  Service {
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }

  Concat {
    owner   => 'opendkim',
    group   => 'opendkim',
    mode    => '0644',
  }


  # Install related package
  package { $packages: }

  # Run service
  service { $service: }

  # Directories
  file { '/etc/opendkim':
    ensure => directory,
    mode   => '0755'
  }

  # Config files init will contain fragment from zones
  concat { $keyTable: }
  concat { $signingTable: }
  concat { $trustedHost: }




  file { $configFile:
    content => template('postfix/dkim/opendkim.conf.erb')
  }

  concat::fragment{'main.cf_dkim':
    target  => '/etc/postfix/main.cf',
    content => template('postfix/dkim/main.cf.erb'),
    order   => 10,
  }

  concat::fragment { "base-trustedHost":
    target  => $postfix::dkim::trustedHost,
    content => template('postfix/dkim/trustedHost.erb'),
    order   => 1,
  }

  # Manual need
  # mail._domainkey.example.com IN TXT "v=DKIM1; h=rsa-sha256; k=rsa;p=AySFjB......xorQAB"

}
