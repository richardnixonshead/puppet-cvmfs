#Class cvmfs::zero::config
#included from instances of cvmfs::zero defined type.
class cvmfs::zero::config {
  file{'/etc/cvmfs/repositories.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => Package['cvmfs-server'],
  }
  file{'/etc/puppet-cvmfs-scripts':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }
  file{'/etc/puppet-cvmfs-scripts/README':
    ensure  => file,
    content => "A few puppet generate scripts to aid operation.\n",
  }
}
