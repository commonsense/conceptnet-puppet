# System package dependencies

class { 'apt':
  update => {
    frequency => 'daily',
  },
}

$dependencies = [
  'build-essential',
  'libhdf5-dev',
  'libmecab-dev',
  'mecab-ipadic-utf8',
  'wget',
]

package { $dependencies:
  ensure  => present,
}

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '10',
  encoding            => 'UTF-8',
}

# Configure unattended-upgrades to upgrade packages every day

include unattended_upgrades

# Create the 'conceptnet' user who will own things

user { 'conceptnet':
  ensure  => 'present',
  shell   => '/bin/bash',
  groups  => 'www-data',
  managehome => true,
}


# PostgreSQL setup

class { 'postgresql::server': }

postgresql::server::role { 'conceptnet':
  superuser => true,
}

postgresql::server::db { 'conceptnet5':
  user      => 'conceptnet',
  password  => undef,
}

postgresql::server::pg_hba_rule { 'allow db access over a local socket':
  type        => 'local',
  database    => 'conceptnet5',
  user        => 'all',
  auth_method => 'trust'
}


# Python and ConceptNet setup

vcsrepo { '/home/conceptnet/conceptnet5':
  ensure   => 'present',
  provider => 'git',
  source   => 'https://github.com/commonsense/conceptnet5.git',
  revision => 'master',
  user     => 'conceptnet',
  require  => User['conceptnet'],
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
  require  => User['conceptnet'],
}

python::pip { 'conceptnet':
  ensure     => 'latest',
  virtualenv => '/home/conceptnet/env',
  pkgname    => '/home/conceptnet/conceptnet5[vectors]',
  owner      => 'conceptnet',
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
  require  => User['conceptnet'],
}

