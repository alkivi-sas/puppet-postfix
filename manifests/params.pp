class postfix::params () {
  case $::operatingsystem {
    /(Ubuntu|Debian)/: {
      $postfix_service_name   = 'postfix'
      $postfix_package_name   = 'postfix'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

