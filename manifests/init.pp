# == Class: bastion_host::init
#
class bastion_host{

  ## ressource ordering
  class { '::ssh_hardening::client':} ->
  class { '::ssh_hardening::server':} 

  ## needed ressources
  include ::ssh_hardening::server
  include ::ssh_hardening::client
  include ::bastion_host::profiles::auditshell
  include ::bastion_host::profiles::mosh

}
