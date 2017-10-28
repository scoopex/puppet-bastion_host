# == Class: bastion_host::profiles::auditshell
#
class bastion_host::profiles::auditshell(
	$file_download_base = 'https://raw.githubusercontent.com/scoopex/scriptreplay_ng/audit-shell/',
){
    ensure_packages([ 'bsdutils', 'apparmor-utils', 'dialog' , 'perl-doc' , 'libterm-readkey-perl' ])

    file { '/var/log/auditshell/':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '1777',
    }

    file { '/usr/local/bin/auditshell-sessions':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => 'puppet:///modules/bastion_host/auditshell-sessions',
    }

		file_line { 'add auditshell':
			path    => '/etc/shells',
			line    =>'/usr/local/bin/auditshell',
			match   => '/usr/local/bin/auditshell',
		}

		exec{'/usr/local/bin/scriptreplay':
		 	command => "/usr/bin/wget -q ${file_download_base}/scriptreplay -O /usr/local/bin/scriptreplay",
		 	creates => '/usr/local/bin/scriptreplay',
		}->
		file{'/usr/local/bin/scriptreplay':
      owner => 'root',
      group => 'root',
		 	mode  => '0755',
		}

		exec{'/usr/local/bin/auditshell':
		 	command => "/usr/bin/wget -q ${file_download_base}/helpers/auditshell -O /usr/local/bin/auditshell",
		 	creates => '/usr/local/bin/auditshell',
		}->
		file{'/usr/local/bin/auditshell':
      owner => 'root',
      group => 'root',
		 	mode  => '0755',
		}

		exec{'/etc/apparmor.d/usr.local.bin.auditshell':
		 	command => "/usr/bin/wget -q ${file_download_base}/helpers/usr.local.bin.auditshell -O /etc/apparmor.d/usr.local.bin.auditshell",
		 	creates => '/etc/apparmor.d/usr.local.bin.auditshell',
		}->
		file{'/etc/apparmor.d/usr.local.bin.auditshell':
      owner => 'root',
      group => 'root',
		 	mode  => '0640',
		}->
    exec { '/usr/sbin/aa-enforce /usr/local/bin/auditshell':
      user        => 'root',
      refreshonly => true,
      path        => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/sbin' ],
    }
}
