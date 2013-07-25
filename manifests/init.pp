class cowbuilder (
  $distribution = params_lookup('distribution'),
) inherits cowbuilder::params {
     class{'cowbuilder::install': }
  -> class{'cowbuilder::config': }
  -> Class['cowbuilder']
}
