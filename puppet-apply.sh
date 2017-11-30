#!/bin/sh
sudo puppet apply manifests/install --modulepath ./modules:/etc/puppet/modules:/usr/share/puppet/modules
