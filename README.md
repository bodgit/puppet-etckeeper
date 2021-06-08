# etckeeper

[![Build Status](https://travis-ci.com/bodgit/puppet-etckeeper.svg?branch=main)](https://travis-ci.com/bodgit/puppet-etckeeper)
[![Codecov](https://img.shields.io/codecov/c/github/bodgit/puppet-etckeeper)](https://codecov.io/gh/bodgit/puppet-etckeeper)
[![Puppet Forge version](http://img.shields.io/puppetforge/v/bodgit/etckeeper)](https://forge.puppetlabs.com/bodgit/etckeeper)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/bodgit/etckeeper)](https://forge.puppetlabs.com/bodgit/etckeeper)
[![Puppet Forge - PDK version](https://img.shields.io/puppetforge/pdk-version/bodgit/etckeeper)](https://forge.puppetlabs.com/bodgit/etckeeper)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with etckeeper](#setup)
    * [What etckeeper affects](#what-etckeeper-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with etckeeper](#beginning-with-etckeeper)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module ensures that etckeeper is set up and configured to keep the `/etc`
directory under version control.

RHEL/CentOS, Ubuntu, Debian, SLES and Arch Linux are supported using Puppet
5 or later.

## Setup

### What etckeeper affects

This module will remove any VCS state directories under `/etc` for any
supported VCS except the one chosen to be used. So for example, if you're
using git, any directories matching `/etc/.bzr`, `/etc/.hg` and `/etc/_darcs`
will be removed. This also means that if you change VCS you will lose any
previous commits.

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository
by using [puppet/epel](https://forge.puppet.com/puppet/epel) or by other
means.

### Beginning with etckeeper

In the very simplest case, you can just include the following:

```puppet
include etckeeper
```

## Usage

For example to configure etckeeper to use a specific VCS instead of going with
the default:

```puppet
class { 'etckeeper':
  vcs => 'bzr',
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-etckeeper/](https://bodgit.github.io/puppet-etckeeper/)
and available also in the [REFERENCE.md](https://github.com/bodgit/puppet-etckeeper/blob/main/REFERENCE.md).

## Limitations

This module has been built on and tested against Puppet 5 and higher.

The module has been tested on:

* Red Hat/CentOS Enterprise Linux 6/7
* Ubuntu 14.04/16.04
* Debian 7/8

It should also work on SLES 11 & 12 and Arch Linux.

## Development

The module relies on [PDK](https://puppet.com/docs/pdk/1.x/pdk.html) and has
both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake spec
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-etckeeper).
