# -*- mode: ruby -*-
# vi: set ft=ruby :

# Before running this, do:
#    vagrant plugin install vagrant-vbguest
# To get the latest VB guest additions installed
# VirtualBox shared folders are seriously broken in current releases. This script
# sets them up because they're better than nothing, but don't rely on it for
# doing any actual work. Instead I check out git repos inside the VM and commit from
# there.


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/groovy64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
    config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
    config.vm.network "forwarded_port", guest: 443, host: 8443, host_ip: "127.0.0.1"
    config.vm.network "forwarded_port", guest: 8081, host: 8081, host_ip: "127.0.0.1"
    config.vm.network "forwarded_port", guest: 8082, host: 8082, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # NOTE: When I made this, the synced folders with Virtualbox were seriously
  # broken. So I switched to using NFS. NFS does not work at all on my Mac though :( . 
  config.vm.synced_folder "~/work", "/home/vagrant/work", type: "vboxsf"
  config.vm.synced_folder "~/devbox-output", "/home/vagrant/devbox-output", type: "vboxsf"

  config.vm.provision "file", source: "~/.git-credentials", destination: ".git-credentials"
  config.vm.provision "file", source: "~/.github-credentials", destination: ".github-credentials"
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
  config.vm.provision "file", source: "~/.gitignore", destination: ".gitignore"
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: ".ssh/id_rsa.pub"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #  vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "8192"
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "setup.sh", privileged: false
end
