# System package dependencies

class { 'apt':
  update => {
    frequency => 'daily',
  },
}

package { 'libhdf5-dev':
  ensure  => 'latest',
}

package { 'build-essential':
  ensure  => 'latest',
}

package { 'wget':
  ensure  => 'latest',
}

package { 'libmecab-dev':
  ensure  => 'latest',
}

package { 'mecab-ipadic-utf8':
  ensure  => 'latest',
}

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '10',
  encoding            => 'UTF-8',
}


# Create the 'conceptnet' user who will own things

user { 'conceptnet':
  ensure  => 'present',
  shell   => '/bin/bash',
  managehome => true,
}


# PostgreSQL setup

class { 'postgresql::server': }

postgresql::server::role { 'conceptnet':
}

postgresql::server::db { 'conceptnet5':
  user      => 'conceptnet',
  password  => undef,
}

postgresql::server::pg_hba_rule { 'allow db access from the command line':
  type        => 'local',
  database    => 'conceptnet5',
  user        => 'all',
  auth_method => 'trust'
}

postgresql::server::pg_hba_rule { 'allow db access over IPv4 localhost':
  type        => 'host',
  database    => 'conceptnet5',
  address     => '127.0.0.1/32',
  user        => 'all',
  auth_method => 'trust',
  order       => '090',
}

postgresql::server::pg_hba_rule { 'allow db access over IPv6 localhost':
  type        => 'host',
  database    => 'conceptnet5',
  address     => '::1/128',
  user        => 'all',
  auth_method => 'trust',
  order       => '091',
}




# Python and ConceptNet setup

vcsrepo { '/home/conceptnet/conceptnet5':
  ensure   => 'present',
  provider => 'git',
  source   => 'https://github.com/commonsense/conceptnet5.git',
  revision => 'puppet',
  user     => 'conceptnet',
}

class { 'python':
  ensure     => 'present',
  version    => 'python3.5',
  pip        => 'present',
  dev        => 'present',
  virtualenv => 'present',
  gunicorn   => 'absent'
}

python::virtualenv { '/home/conceptnet/env':
  ensure     => 'present',
  version    => '3.5',
  systempkgs => false,
  venv_dir   => '/home/conceptnet/env',
  owner      => 'conceptnet',
}

python::pip { 'conceptnet':
  ensure     => 'latest',
  virtualenv => '/home/conceptnet/env',
  pkgname    => '/home/conceptnet/conceptnet5[vectors]',
  egg        => 'ConceptNet',
  install_args => '-e',
  require    => Vcsrepo['/home/conceptnet/conceptnet5'],
}


# Some conveniences when at an interactive shell as the conceptnet user:
# the Python environment with ConceptNet in it should be activated, and
# IPython should be installed.

python::pip { 'ipython':
  ensure     => 'latest',
  virtualenv => '/home/conceptnet/env',
  pkgname    => 'ipython',
}

file { '/home/conceptnet/.bashrc':
  ensure  => 'present',
  content => 'source /home/conceptnet/env/bin/activate',
}

