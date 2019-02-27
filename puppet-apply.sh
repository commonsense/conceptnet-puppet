#!/bin/sh
sudo puppet apply manifests/install --modulepath ./modules:/etc/puppet/modules:/etc/puppet/code/modules:/etc/puppetlabs/code/modules:/usr/share/puppet/modules
