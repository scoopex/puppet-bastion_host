# This file is only used for testing purposes

##################################################
#### MOCK CLASSES WHICH SHOULD NOT TESTED HERE
class bastion_host2(
  Hash $config = {},
) {
  notice( 'mocked class ==> bastion_host::foobar' )
}

# INCLUDE THE CLASS
include ::bastion_host

