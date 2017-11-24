# == Class: bastion_host::profiles::auditshell
#
class bastion_host::profiles::auditshell(
	$file_download_base = 'https://raw.githubusercontent.com/scoopex/scriptreplay_ng/audit-shell/',
){
    ensure_packages([ 'bsdutils', 'apparmor-utils', 'perl-doc' , 'libterm-readkey-perl' ])

    file { [ '/var/log/auditshell/', '/var/log/auditshell/sessions', '/var/log/auditshell/actions' ]:
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

		file{'/usr/local/bin/auditshell':
      owner  => 'root',
      group  => 'root',
		 	mode   => '0755',
      source => 'puppet:///modules/bastion_host/auditshell',
    }

		file{'/usr/local/bin/auditshell-maintain':
      owner  => 'root',
      group  => 'root',
		 	mode   => '0755',
      source => 'puppet:///modules/bastion_host/auditshell-maintain',
    }

		file{'/etc/cron.d/auditshell':
      owner   => 'root',
      group   => 'root',
		 	mode    => '0755',
      content =>"*/15 * * * root ionice -c3 nice -n 20 /usr/local/bin/auditshell-maintain 2>&1|logger -t auditshell"
    }

		file{'/etc/apparmor.d/usr.local.bin.auditshell':
      owner  => 'root',
      group  => 'root',
		 	mode   => '0640',
      source => 'puppet:///modules/bastion_host/usr.local.bin.auditshell',
		}
    exec { '/usr/sbin/aa-enforce /usr/local/bin/auditshell':
      user        => 'root',
      refreshonly => true,
      subscribe   => File['/etc/apparmor.d/usr.local.bin.auditshell'],
    }

		file{'/etc/apparmor.d/usr.local.bin.auditshell-sessions':
      owner  => 'root',
      group  => 'root',
		 	mode   => '0640',
      source => 'puppet:///modules/bastion_host/usr.local.bin.auditshell-sessions',
		}
    exec { '/usr/sbin/aa-enforce /usr/local/bin/auditshell-sessions':
      user        => 'root',
      refreshonly => true,
      subscribe   => File['/etc/apparmor.d/usr.local.bin.auditshell-sessions'],
    }

}
