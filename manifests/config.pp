class cowbuilder::config {
  $distribution = $cowbuilder::distribution
  $etcfile      = '/etc/cowbuilder.distribution'
  $cow_command  = "cowbuilder --distribution $distribution"

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
