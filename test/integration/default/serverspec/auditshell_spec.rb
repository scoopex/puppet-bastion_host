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
  its(:exit_status) { should eq 2 }
end

describe command('su - -c "uptime; ls -l /etc/fstab /etc/not-existing" testuser') do
  its(:stdout) { should match(/average/) }
  its(:stdout) { should match(/fstab/) }
  its(:stderr) { should match(/No such file or directory/) }
  its(:exit_status) { should eq 2 }
end

describe command('su - -c "ssh localhost uptime" testuser') do
  its(:stdout) { should match(/average/) }
  its(:exit_status) { should eq 0 }
end

describe command('scp -i /home/testuser/.ssh/id_rsa -o StrictHostKeyChecking=no testuser@localhost:/etc/fstab /tmp/copyfrom;cat /tmp/copyfrom') do
  its(:stdout) { should match(/defaults/) }
  its(:exit_status) { should eq 0 }
end

describe command('scp -i /home/testuser/.ssh/id_rsa -o StrictHostKeyChecking=no /etc/fstab localhost:/tmp/copyto;cat /tmp/copyto') do
  its(:stdout) { should match(/defaults/) }
  its(:exit_status) { should eq 0 }
end

describe command('touch stamp; screen -mdS test bash -c '+
                 '"timeout -k 1 2 ssh -o StrictHostKeyChecking=no -i /home/testuser/.ssh/id_rsa testuser@localhost"; '+
                 'sleep 1;find /var/log/auditshell/sessions -type f -newer stamp') do
   its(:stdout) { should match(/typescript.*testuser.*/) }
   its(:stdout) { should match(/timing.*testuser.*/) }
end


#----------------------------------------------------------------------

