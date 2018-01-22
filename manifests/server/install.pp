# Class - cvmfs::server::install
class cvmfs::server::install (
  $cvmfs_version        = hiera("cvmfs::cvmfs_version"),
  $cvmfs_kernel_version = hiera("cvmfs::server::cvmfs_kernel_version"),
  $cvmfs_aufs2_version  = hiera("cvmfs::server::cvmfs_aufs2_version"),
) {

  class{'::cvmfs::server::yum':}

  package{['cvmfs-server','cvmfs']:
    ensure  => $cvmfs_version,
    require => Yumrepo['cvmfs'],
  }
  package{'kernel':
    ensure  => $cvmfs_kernel_version,
    require => Yumrepo['cvmfs-kernel'],
  }
  package{'aufs2-util':
    ensure => $cvmfs_aufs2_version,
  }
  ensure_packages('httpd', { ensure => present, })
}



