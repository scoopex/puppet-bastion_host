#----------------------------------------------------------------------
# instantiating testing requirements
#----------------------------------------------------------------------

if (!ENV['w_ssh'].nil? && ENV['w_ssh'] = 'true')
  begin
    require 'spec_helper.rb'
  rescue LoadError
  end
else
  begin
    require 'spec_helper.rb'
    set :backend, :exec
  rescue LoadError
  end
end
#----------------------------------------------------------------------

#  http://serverspec.org/resource_types.html

#----------------------------------------------------------------------
# testing basic function
#----------------------------------------------------------------------

describe command('su - -c "ls -1 /var/log/auditshell/ /etc/fstab" testuser') do
  its(:stderr) { should match(/Permission denied/) }
end

describe command('su - -c "uptime; ls -l /etc/fstab /etc/not-existing" testuser') do
  its(:stdout) { should match(/average/) }
  its(:stdout) { should match(/fstab/) }
  its(:stderr) { should match(/No such file or directory/) }
end

describe command('su - -c "ssh localhost uptime" testuser') do
  its(:stdout) { should match(/average/) }
end

describe command('su - -c "scp localhost:/etc/fstab /tmp/copyfrom;cat /tmp/copyfrom" testuser') do
  its(:stdout) { should match(/defaults/) }
end

describe command('su - -c "scp /etc/fstab localhost:/tmp/copyto;cat /tmp/copyto" testuser') do
  its(:stdout) { should match(/defaults/) }
end

describe command('touch stamp; screen -mdS test bash -c "timeout -k 1 2 ssh -o StrictHostKeyChecking=no -i /home/testuser/.ssh/id_rsa testuser@localhost"; find /var/log/auditshell -type f -newer stamp') do
   its(:stdout) { should match(/typescript.*testuser.*/) }
   its(:stdout) { should match(/timing.*testuser.*/) }
end


#----------------------------------------------------------------------

