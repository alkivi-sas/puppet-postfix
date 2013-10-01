class postfix::install () {
  package { $postfix::params::postfix_package_name:
    ensure => installed,
  }
}
