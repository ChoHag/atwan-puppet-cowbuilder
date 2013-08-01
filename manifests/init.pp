class cowbuilder (
  $distribution = params_lookup('distribution'),
  $http_proxy   = params_lookup('http_proxy',  'global'),
) inherits cowbuilder::params {
     class{'cowbuilder::install': }
  -> class{'cowbuilder::config': }
  -> Class['cowbuilder']
}
