#Class: cvmfs::zero::install , desingned
#to be included from instances of cvmfs::zero
class cvmfs::zero::install (
  $cvmfs_version        = $::cvmfs::cvmfs_version,
  $cvmfs_kernel_version = $::cvmfs::cvmfs_kernel_version,
  $cvmfs_aufs2_version  = $::cvmfs::cvmfs_aufs2_version,
  $cvmfs_zero_manage_httpd = $::cvmfs::cvmfs_zero_manage_httpd,
) {
  include ::cvmfs::zero::yum

  package{['cvmfs-server']:
    ensure  => $cvmfs_version,
    require => Yumrepo['cvmfs'],
  }

  # If it is running on el6, check for aufs kernel
  #

  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == "6" {

    unless $::kernelrelease  =~ /^.*aufs.*/ {
      notify{'An aufs kernel is not, install, upgrade, reboot until an aufs kernel is running':}
    }

    package{'kernel':
      ensure  => $cvmfs_kernel_version,
      require => Yumrepo['cvmfs-kernel'],
    }
    package{'aufs2-util':
      ensure  => $cvmfs_aufs2_version,
      require => Yumrepo['cvmfs-kernel'],
    }
  }

  if ($cvmfs_zero_manage_httpd) {
    ensure_packages('httpd', { ensure => present, } )
  }
}
