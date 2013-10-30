class postfix::alkivi(
) {
  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['postfix::service'],
  }

  file { '/etc/postfix/header_checks':
    content => template('postfix/header_checks.erb'),
    mode    => '0755',
  }
}
