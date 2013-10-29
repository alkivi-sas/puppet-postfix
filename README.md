# postfix Module

This module will install and configure a postfix server and allow you to manage spf and dkim configuration as well

## Usage

### Server configuration

```puppet
class { 'postfix': 
  myorigin        => 'web.alkivi.fr',
  myhostname      => 'web.alkivi.fr',
  mydestination   => ['web.alkivi.fr', 'localhost'],
  rootAlias       => 'monitoring@alkivi.fr',
  inet_interfaces => 'loopback-only',
  mynetworks      => [],
  motd            => true,
}
```
This will do the typical install, configure and service management.

### DKIM support
```puppet
class { 'postfix::dkim':
  hostname => 'web.alkivi.fr',
}

you will have to manually put a DKIM (TXT) entry in your dns as show in the files :
/etc/opendkim/your_domain_name/mail.txt

### SPF support
```puppet
class { 'postfix::spf': }
```

For SPF, you have to do the same. A SPF DNS entry looks like:
v=spf1  a:home.themartinets.com  ip4:92.168.20.253 mx:home.themartinets.com ~all


## Limitations

* This module has been tested on Debian Wheezy, Squeeze.

## License

All the code is freely distributable under the terms of the LGPLv3 license.

## Contact

Need help ? contact@alkivi.fr

## Support

Please log tickets and issues at our [Github](https://github.com/alkivi-sas/)
