# == Class: cvmfs::services
# Manages the cvmfs services. Optinally this also manages the autofs services
# as well.
#
# === Parameters
#
# === Authors
#
# Steve Traylen <steve.traylen@cern.ch>
#
# === Copyright
#
# Copyright 2012 CERN
#
class cvmfs::service (
  $mount_method          = $cvmfs::mount_method,
  $manage_autofs_service = $cvmfs::manage_autofs_service,
  $cvmfs_reload_timeout  = $cvmfs::cvmfs_reload_timeout,
) inherits cvmfs {

  # CVMFS 2.1 at least uses cvmfs_config.

  exec{'Reloading cvmfs':
    command     => '/usr/bin/cvmfs_config reload',
    refreshonly => true,
    timeout     => $cvmfs_reload_timeout,
  }
  if $manage_autofs_service and $mount_method == 'autofs' {
    ensure_resource('service','autofs',
      { ensure     => true,
        enable     => true,
        hasrestart => true,
      }
    )
  }
}

