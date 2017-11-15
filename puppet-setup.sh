#!/bin/sh
# Install Ubuntu's packages for Puppet. On Xenial, it gets v3.8.5.
sudo apt-get install puppet-common

# Get Puppet module that lets us use apt commands
sudo puppet module install puppetlabs-apt
# Get Puppet module that lets us setup postgresql
sudo puppet module install puppetlabs-postgresql
# Get Puppet module that lets us pull repos
sudo puppet module install puppetlabs-vcsrepo
# Get the Puppet module that lets us work with Python and Pip.
sudo puppet module install stankevich-python

