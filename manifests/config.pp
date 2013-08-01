class cowbuilder::config {
  $distribution = $cowbuilder::distribution
  $http_proxy   = $cowbuilder::http_proxy
  if $cowbuilder::config::http_proxy and $cowbuilder::config::http_proxy != 'UNDEFINED' {
    $cow_proxy = "--http-proxy ${cowbuilder::config::http_proxy}"
  }
  $etcfile      = '/etc/cowbuilder.distribution'
  $cow_command  = "cowbuilder --distribution $distribution $cow_proxy"

  exec { $etcfile:
    command => "bash -c 'echo $distribution > $etcfile'",
    onlyif  => "test ! -f $etcfile || cat $etcfile | grep -v ^$distribution\$",
    notify  => Exec['cowbuilder-update'],
  }

  -> exec { 'cowbuilder-create':
    command => "$cow_command --create",
    creates => "/var/cache/pbuilder/base.cow",
    timeout => 0,
  }

  -> exec { 'cowbuilder-update':
    command => "$cow_command --update",
    timeout => 0,
    refreshonly => true,
  }

  case $::osfamily {
    Debian: {
      Apt::Update { notify => Exec['cowbuilder-update'] }
    }
  }
}
