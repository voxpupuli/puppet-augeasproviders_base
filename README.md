[![Build Status](https://github.com/voxpupuli/puppet-augeasproviders_base/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-augeasproviders_base/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-augeasproviders_base/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-augeasproviders_base/actions/workflows/release.yml)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-augeasproviders_base/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-augeasproviders_base)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/augeasproviders_base.svg)](https://forge.puppetlabs.com/puppet/augeasproviders_base)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/augeasproviders_base.svg)](https://forge.puppetlabs.com/puppet/augeasproviders_base)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/augeasproviders_base.svg)](https://forge.puppetlabs.com/puppet/augeasproviders_base)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/augeasproviders_base.svg)](https://forge.puppetlabs.com/puppet/augeasproviders_base)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-augeasproviders_base)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-augeasproviders_base.svg)](LICENSE)
[![Donated by Camptocamp](https://img.shields.io/badge/donated%20by-camptocamp-fb7047.svg)](#transfer-notice)

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

The module can be installed easily ([documentation](http://docs.puppetlabs.com/puppet/latest/reference/modules_installing.html)):

```
puppet module install puppet/augeasproviders_base
```

## Compatibility

### Puppet versions

See `metadata.json`.

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

Please file any issues or suggestions [on GitHub](https://github.com/voxpupuli/puppet-augeasproviders_core/issues).

## Transfer Notice

This plugin was originally authored by [hercules-team](http://augeasproviders.com).
The maintainer preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/hercules-team/augeasproviders_core
