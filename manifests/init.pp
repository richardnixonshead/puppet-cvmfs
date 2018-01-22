# == Class: cvmfs
class cvmfs (
  $mount_method,
  $config_automaster,
  $manage_autofs_service,
  $default_cvmfs_partsize,
  $cvmfs_quota_limit,
  $cvmfs_quota_ratio,
  $cvmfs_http_proxy,
  $cvmfs_cache_base,
  $cvmfs_claim_ownership,
  $cvmfs_mount_rw,
  $cvmfs_memcache_size,
  $cvmfs_timeout,
  $cvmfs_timeout_direct,
  $cvmfs_nfiles,
  $cvmfs_force_signing,
  $cvmfs_syslog_level,
  $cvmfs_tracefile,
  $cvmfs_debuglog,
  $cvmfs_max_ttl,
  $cvmfs_env_variables,
  $cvmfs_hash,
  $cvmfs_domain_hash,
  $cvmfs_version,
  $cvmfs_yum,
  $cvmfs_yum_config,
  $cvmfs_yum_config_enabled,
  $cvmfs_yum_proxy,
  $cvmfs_yum_testing,
  $cvmfs_yum_testing_enabled,
  $cvmfs_yum_gpgcheck,
  $cvmfs_yum_gpgkey,
  $cvmfs_use_geoapi,
  $cvmfs_server_url,
  $cvmfs_follow_redirects,
  $cvmfs_yum_manage_repo,
  $cvmfs_repo_list,
) {

  # For now just check os and exit if it untested.
  if $::osfamily == 'RedHat' and $::operatingsystem == 'Fedora' {
     fail('This cvmfs module has not been verified under fedora.')
  } elsif $::osfamily != 'RedHat' {
     fail('This cvmfs module has not been verified under osfamily other than RedH
  }

  # Deprecations
  if $config_automaster == false {
    fail('config_automaster set to false is deprecated, please set cvmfs::mount_method explicitly to autofs(the default), mount or none instead.')
  }

  if $cvmfs_server_url != ''  {
    warning('The $cvmfs_server_url to cvmfs is deprecated, please set this value per mount or per domain.')
  }

  validate_bool($cvmfs_yum_manage_repo)
  validate_re($mount_method,['^autofs$','^mount$','^none$'],'$mount_method must be one of autofs (default), mount or none')

  anchor{'cvmfs::begin':}
  -> class{'::cvmfs::install':}
  -> class{'::cvmfs::config':}
  ~> class{'::cvmfs::service':}
  -> anchor{'cvmfs::end':}

  # Finally allow the individual repositories to be loaded from hiera.
  if is_hash($cvmfs_hash) {
    create_resources('cvmfs::mount', $cvmfs_hash)
  }
  if is_hash($cvmfs_domain_hash) {
    create_resources('cvmfs::domain', $cvmfs_domain_hash)
  }

}
