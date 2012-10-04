# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
class foreman::puppetmaster (
  $foreman_url    = $foreman::params::foreman_url,
  $facts          = $foreman::params::facts,
  $storeconfigs   = $foreman::params::storeconfigs,
  $puppet_home    = $foreman::params::puppet_home,
  $puppet_basedir = $foreman::params::puppet_basedir
) inherits foreman::params {

  if $foreman::params::reports {   # foreman reporter
    file {"${puppet_basedir}/reports/foreman.rb":
      mode     => '0444',
      owner    => 'puppet',
      group    => 'puppet',
      content  => template('foreman/foreman-report.rb.erb'),
      require  => Class['::puppet::server::install'],
      # notify => Service["puppetmaster"],
    }
  }

  if $foreman::params::enc     {
    class {'foreman::config::enc':
      foreman_url  => $foreman_url,
      facts        => $facts,
      storeconfigs => $storeconfigs,
      puppet_home  => $puppet_home,
    }
  }
}
