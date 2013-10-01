class postfix::dkim (
  $hostname,
  $certificate_name = 'mail',
  $dns_servers      = ['ns102.ovh.net', 'dns102.ovh.net'],
  $canonicalization = 'relaxed/relaxed',
) {

  validate_string($hostname)

  $packages     = ['opendkim', 'opendkim-tools']
  $service      = 'opendkim'
  $keyTable     = '/etc/opendkim/KeyTable'
  $trustedHost  = '/etc/opendkim/TrustedHosts'
  $signingTable = '/etc/opendkim/SigningTable'


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


  # Install related package
  package { $packages: }

  # Run service
  service { $service: }

  # Directories
  file { '/etc/opendkim':
    ensure => directory,
    mode   => '0755'
  }

  file { "/etc/opendkim/${hostname}":
    ensure  => directory,
    mode    => '0700',
    require => File['/etc/opendkim'],
  }

  # Certificates
  exec { 'generate-dkim-certificate':
    command => "opendkim-genkey -r -h rsa-sha256 -d ${hostname} -D /etc/opendkim/${hostname} -s ${certificate_name} && mv /etc/opendkim/${hostname}/${certificate_name}.private /etc/opendkim/${hostname}/${certificate_name} && chmod u=rw,go-rwx /etc/opendkim/${hostname}/* && chown opendkim:opendkim /etc/opendkim/${hostname}/*",
    creates => "/etc/opendkim/${hostname}/${certificate_name}",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => [ File["/etc/opendkim/${hostname}"], Package[$packages] ],
  }

  # Config files
  file { $keyTable:
    content => template('postfix/dkim/keyTable.erb'),
    require => File['/etc/opendkim'],
  }

  file { $signingTable:
    content => template('postfix/dkim/signingTable.erb'),
    require => File['/etc/opendkim'],
  }

  file { $trustedHost:
    content => template('postfix/dkim/trustedHost.erb'),
    require => File['/etc/opendkim'],
  }

  file { '/etc/opendkim.conf':
    content => template('postfix/dkim/opendkim.conf.erb')
  }

  concat::fragment{'main.cf_dkim':
    target  => '/etc/postfix/main.cf',
    content => template('postfix/dkim/main.cf.erb'),
    order   => 10,
  }

  # Manual need
  # mail._domainkey.example.com IN TXT "v=DKIM1; h=rsa-sha256; k=rsa;p=AySFjB......xorQAB"

}
