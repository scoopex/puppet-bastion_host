Overview
--------

This project based on https://github.com/scoopex/puppet-bastion_host

This puppet project template provides the following aspects:

  * a security hardened openssh server setup
  * a audit shell which logs all executions shell interaction, scp and rsync file transfers and remote command execution
  * forbid auditshell users to modify and read the auditshell logs
  * review previous shell sessions by a reimplementaion of "scriptreplay"

Usage
-----

  * Add users with "/usr/local/bin/auditshell" as user shell to log their sessions
  * Add administrative users with the group "auditshell" to give them the ability to review the shell sessions of other users
  * Review shell sessions using the script "auditshell-sessions"<BR>
    (check "perldoc /usr/local/bin/auditshell" for hotkeys how to user the replay feature)
 

Installation of the test environment
------------------------------------

  * Install virtualbox: https://www.virtualbox.org/wiki/Linux_Downloads
  * Installation of vagrant
   * see: https://www.vagrantup.com/downloads.html
   * Download und Installation
     ```
     cd /tmp
     wget https://releases.hashicorp.com/vagrant/2.0.0/vagrant_2.0.0_x86_64.deb
     sudo dpkg -i vagrant_2.0.0_x86_64.deb
     ```
  * Clone the repo
    ```
    git clone https://github.com/scoopex/puppet-bastion_host.git
    cd puppet-bastion_host
    ```
  * Installation of RVM
     * Follow the offical installation procedure at https://rvm.io/, i.e.:
       ```
       gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
       \curl -sSL https://get.rvm.io | bash -s stable
       source /home/marc/.rvm/scripts/rvm
       rvm install "ruby-2.4.1"
       ```
     * Configuration of RVM<br>
       After the rvm installtion a configuration file (~/.rvmrc) should be created with the following content:
       ```
       echo "rvm_autoinstall_bundler_flag=1" >> ~/.rvmrc
       ```
       This allows the convinient automatic installation of bundler.

     * Install Ruby, work with control repositories
       There are numerous possibilities to work with RVM - we are unsing the Gemfile procedure.
       see: Gemfile
       ```
       source 'https://rubygems.org'

       #ruby=2.0.0-p645
       #ruby-gemset=puppet-testing

       (...)
       ```
       The entries with the leading hashes (#) are not disabled entries. You have to install the configured ruby release in a manual procedure.
       You will get a notification "Required ruby-2.4.1 is not installed." if this step is missing.

       "test-kitchen": Serverspec Test mit Vagrant/Virtualbox/Docker
       ```
       exec bash
       cd ..; cd puppet-bastion_host
       # Frägt nach Sudo Passwort: Installiert libyaml-dev, libsqlite3-dev, libgdbm-dev, libncurses5-dev, bison, libreadline6-dev
       rvm install ruby-2.4
       # Now the automatic invocation of bundler should install all the missing gems
       cd ..; cd puppet-bastion_host
       ```

Develop and test puppet code
-------------------------------

 * Change to the directory
   ```
   cd puppet-bastion_host
   ```
 * Deploy a test system and login to the system for debugging purposes
   ```
   kitchen create
   kitchen login
   sudo bash
   ```
 * Execute puppet withe the current code
   ```
   kitchen converge
   ```
 * Execute serverspec tests
   ```
   kitchen verify
   ```


Cheat Sheet
-----------

  ```
  Command                  Description
  kitchen list             View all test suites
  kitchen create           Create the target system (Vagrant)
  kitchen create <suite>
  kitchen converge <suite> Execute puppet (Puppet)
  kitchen login <suite>    SSH Login
  kitchen verify <suite>   Execute test suites (servespec)
  kitchen test <suite>     Create, test and destroy system
  kitchen destroy          Destroy all test systems
  kitchen destroy <suite>  Destroy a certain test system
  ```

