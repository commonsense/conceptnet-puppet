#!/bin/sh
sudo puppet apply manifests/ --modulepath ./modules:/etc/puppet/modules:/usr/share/puppet/modules
