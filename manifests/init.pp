# == Class: bastion_host::init
#
class bastion_host{

  ## ressource ordering
  class { '::bastion_host2':} ->
  class { '::bastion_host::profiles::lighttpd':}

  ## needed ressources
  include ::bastion_host2
  include ::bastion_host::profiles::lighttpd
}
