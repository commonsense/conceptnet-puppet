#!/bin/sh
# Install Ubuntu's packages for Puppet. On Xenial, it gets v3.8.5.
#
# (I also tried Puppet 5 packages directly from Puppetlabs, but they seem to
# no longer provide a standalone 'puppet apply' command that doesn't require
# setting up a server.)
sudo apt install puppet-common puppet-module-puppetlabs-postgresql puppet-module-puppetlabs-vcsrepo

# Get the Puppet module that lets us work with Python and Pip.
sudo puppet module install stankevich-python
