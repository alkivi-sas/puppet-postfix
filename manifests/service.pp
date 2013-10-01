class postfix::service () {
  service { $postfix::params::postfix_service_name:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}

