class postfix::config (
  $myorigin        = $postfix::myorigin,
  $myhostname      = $postfix::myhostname,
  $mydestination   = $postfix::mydestination,
  $mynetworks      = $postfix::mynetworks,
  $inet_interfaces = $postfix::inet_interfaces,
) {
  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['postfix::service'],
  }

  concat{ '/etc/postfix/main.cf':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat{ '/etc/postfix/master.cf':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat::fragment{'main.cf_main':
    target  => '/etc/postfix/main.cf',
    content => template('postfix/main.cf.erb'),
    order   => 01,
  }

  concat::fragment{'master.cf_main':
    target  => '/etc/postfix/master.cf',
    content => template('postfix/master.cf.erb'),
    order   => 01,
  }

  if($postfix::inet_interfaces == 'all')
  {
    if($postfix::firewall)
    {
      file { '/etc/iptables.d/25-postfix.rules':
        source  => 'puppet:///modules/postfix/postfix.rules',
        require => Package['alkivi-iptables'],
        notify  => Service['alkivi-iptables'],
      }
    }
  }

}
