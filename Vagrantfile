# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require './vagrant/vagrant_extras'
extend VagrantExtras

# check and install required Vagrant plugins
check_plugins(%w(vagrant-multi-hostsupdater vagrant-vbguest vagrant-cachier))

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Using the latest 14.04 Ubuntu Server (LTS)
  vm_box(config)

  config.vm.synced_folder ".", "/var/www/lords", nfs: true
  config.vm.network "private_network", ip: '192.168.77.41'
  config.vm.provider "virtualbox" do |v|
    v.memory = 2096
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--name", "TheLords"]
  end

  # Set entries in hosts file
  config.vm.hostname = "the-lords.org"
  host_aliases = ['ape-test.local', 'ape.the-lords.org']
  for i in 0..39
    host_aliases << "#{i}.ape.the-lords.org"
  end
  config.multihostsupdater.aliases = host_aliases

  # Enable cache
  cache_scope(config)

  # Ansible playbook provision
  ansible_playbook_provision(config, 'ansible/lords.yml')

  # Start Ajax Push Engine (APE) and AI
  config.vm.provision :shell, inline: "cd /var/www/lords/ape_scripts/bin ; chmod 755 ./aped ; ./aped", run: 'always'
  config.vm.provision :shell, inline: "cd /var/www/lords/deployment ; chmod 755 ./deploy_ai.sh ; ./deploy_ai.sh vagrant", run: 'always'
end
