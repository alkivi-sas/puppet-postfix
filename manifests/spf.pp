class postfix::spf (
) {

  $packages = 'postfix-policyd-spf-perl'

  Package {
    ensure => installed,
  }

  # Install related package
  package { $packages: }

  # Config files
  concat::fragment{'main.cf_spf':
    target  => '/etc/postfix/main.cf',
    content => template('postfix/spf/main.cf.erb'),
    order   => 10,
  }

  concat::fragment{'master.cf_spf':
    target  => '/etc/postfix/master.cf',
    content => template('postfix/spf/master.cf.erb'),
    order   => 10,
  }

  # Manually need to update dns
  # v=spf1  a:home.themartinets.com  ip4:192.168.20.253 mx:home.themartinets.com ~all


  }
