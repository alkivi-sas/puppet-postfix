class postfix (
  $myorigin,
  $myhostname,
  $mydestination,
  $rootAlias,
  $mynetworks      = [],
  $inet_interfaces = 'all',
  $dkim            = true,
  $spf             = true,
  $motd            = true,
) {


  if($motd)
  {
    motd::register{ 'Postfix Server': }
  }

  validate_string($myorigin)
  validate_string($myhostname)
  validate_string($rootAlias)
  validate_string($inet_interfaces)
  validate_array($mynetworks)
  validate_array($mydestination)

  # declare all parameterized classes
  class { 'postfix::params': }
  class { 'postfix::install': }
  class { 'postfix::config':
    rootAlias => $rootAlias,
  }
  class { 'postfix::service': }

  if($dkim)
  {
    class { 'postfix::dkim':
      hostname => $myhostname
    }
  }

  if($spf)
  {
    class { 'postfix::spf': }
  }


  # declare relationships
  Class['postfix::params'] ->
  Class['postfix::install'] ->
  Class['postfix::config'] ->
  Class['postfix::service']
}

