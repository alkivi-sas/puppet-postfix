class postfix (
  $myorigin,
  $myhostname,
  $mydestination,
  $mynetworks      = [],
  $inet_interfaces = 'all',
  $motd            = true,
  $firewall        = true,
) {


  if($motd)
  {
    motd::register{ 'Postfix Server': }
  }

  validate_string($myorigin)
  validate_string($myhostname)
  validate_string($inet_interfaces)
  validate_array($mynetworks)
  validate_array($mydestination)

  # declare all parameterized classes
  class { 'postfix::params': }
  class { 'postfix::install': }
  class { 'postfix::config': }
  class { 'postfix::service': }


  # declare relationships
  Class['postfix::params'] ->
  Class['postfix::install'] ->
  Class['postfix::config'] ->
  Class['postfix::service']
}

