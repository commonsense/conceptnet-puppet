#!/bin/sh
# Install Ubuntu's packages for Puppet. On Xenial, it gets v3.8.5.
#
# (I also tried Puppet 5 packages directly from Puppetlabs, but they seem to
# no longer provide a standalone 'puppet apply' command that doesn't require
# setting up a server.)
. /etc/os-release
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-${VERSION_CODENAME}.deb
sudo dpkg -i puppetlabs-release-pc1-${VERSION_CODENAME}.deb
sudo apt-get install puppet-common

# Get Puppet module that lets us use apt commands
sudo puppet module install puppetlabs-apt
# Get Puppet module that lets us setup postgresql
sudo puppet module install puppetlabs-postgresql
# Get Puppet module that lets us pull repos
sudo puppet module install puppetlabs-vcsrepo
# Get the Puppet module that lets us work with Python and Pip.
sudo puppet module install stankevich-python
