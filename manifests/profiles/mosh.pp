# == Class: bastion_host::profiles::mosh
#
class bastion_host::profiles::mosh(
){
    ensure_packages([ "mosh", ])
}
