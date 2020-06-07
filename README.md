[![Puppet Forge Version](http://img.shields.io/puppetforge/v/herculesteam/augeasproviders_base.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_base)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/herculesteam/augeasproviders_base.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_base)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/herculesteam/augeasproviders_base.svg)](https://forge.puppetlabs.com/herculesteam/augeasproviders_base)
[![Build Status](https://img.shields.io/travis/hercules-team/augeasproviders_base/master.svg)](https://travis-ci.org/hercules-team/augeasproviders_base)
[![Coverage Status](https://img.shields.io/coveralls/hercules-team/augeasproviders_base.svg)](https://coveralls.io/r/hercules-team/augeasproviders_base)
[![Gemnasium](https://img.shields.io/gemnasium/hercules-team/augeasproviders_base.svg)](https://gemnasium.com/hercules-team/augeasproviders_base)
[![Sponsor](https://img.shields.io/badge/%E2%99%A5-Sponsor-hotpink.svg)](https://github.com/sponsors/raphink)


# base: additional providers for Puppet base types

This module provides additional providers for Puppet base types
using the Augeas configuration library.

The advantage of using Augeas over the default Puppet `parsedfile`
implementations is that Augeas will go to great lengths to preserve file
formatting and comments, while also failing safely when needed.

This provider will hide *all* of the Augeas commands etc., you don't need to
know anything about Augeas to make use of it.

## Requirements

Ensure both Augeas and ruby-augeas 0.3.0+ bindings are installed and working as
normal.

See [Puppet/Augeas pre-requisites](http://docs.puppetlabs.com/guides/augeas.html#pre-requisites).

## Installing

On Puppet 2.7.14+, the module can be installed easily ([documentation](http://docs.puppetlabs.com/puppet/latest/reference/modules_installing.html)):

    puppet module install herculesteam/augeasproviders_base


## Compatibility

### Puppet versions

Minimum of Puppet 2.7.

### Augeas versions

Augeas Versions           | 0.10.0  | 1.0.0   | 1.1.0   | 1.2.0   |
:-------------------------|:-------:|:-------:|:-------:|:-------:|
**PROVIDERS**             |
host                      | **yes** | **yes** | **yes** | **yes** |
mailalias                 | **yes** | **yes** | **yes** | **yes** |

## Documentation and examples

Type documentation can be generated with `puppet doc -r type` or viewed on the
[Puppet Forge page](http://forge.puppetlabs.com/herculesteam/augeasproviders_base).

### host provider

This is a provider for a type distributed in Puppet core: [host type
reference](http://docs.puppetlabs.com/references/stable/type.html#host).

The provider needs to be explicitly given as `augeas` to use `augeasproviders`.

The `comment` parameter is only supported on Puppet 2.7 and higher.

#### manage simple entry

    host { "example":
      ensure   => present,
      ip       => "192.168.1.1",
      provider => augeas,
    }

#### manage entry with aliases and comment

    host { "example":
      ensure       => present,
      ip           => "192.168.1.1",
      host_aliases => [ "foo-a", "foo-b" ],
      comment      => "test",
      provider     => augeas,
    }

#### manage entry in another location

    host { "example":
      ensure   => present,
      ip       => "192.168.1.1",
      target   => "/etc/anotherhosts",
      provider => augeas,
    }

#### delete entry

    host { "iridium":
      ensure   => absent,
      provider => augeas,
    }

#### remove aliases

    host { "iridium":
      ensure       => present,
      host_aliases => [],
      provider     => augeas,
    }

#### remove comment

    host { "argon":
      ensure   => present,
      comment  => "",
      provider => augeas,
    }


### mailalias provider

This is a provider for a type distributed in Puppet core: [mailalias type
reference](http://docs.puppetlabs.com/references/stable/type.html#mailalias).

The provider needs to be explicitly given as `augeas` to use `augeasproviders`.

#### manage simple entry

    mailalias { "example":
      ensure    => present,
      recipient => "bar",
      provider  => augeas,
    }

#### manage entry with multiple recipients

    mailalias { "example":
      ensure    => present,
      recipient => [ "fred", "bob" ],
      provider  => augeas,
    }

#### manage entry in another location

    mailalias { "example":
      ensure    => present,
      recipient => "bar",
      target    => "/etc/anotheraliases",
      provider  => augeas,
    }

#### delete entry

    mailalias { "mailer-daemon":
      ensure   => absent,
      provider => augeas,
    }


## Issues

Please file any issues or suggestions [on GitHub](https://github.com/hercules-team/augeasproviders_base/issues).
