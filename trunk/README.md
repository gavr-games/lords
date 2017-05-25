# The Lords

Getting Started
---------------

The general idea is to have a VM with Lords installed and working inside of it. Any developer will be able to quickly bring it up and test/develop.
We use Vagrant and Ansible to provision our development environment.
You can [install Vagrant here](http://www.vagrantup.com/downloads)
You will also need to [install VirtualBox](https://www.virtualbox.org/wiki/Downloads) from Oracle. 
Also you need to [install Ansible](http://docs.ansible.com/ansible/intro_installation.html). This will be used to provision the VM with needed software.

Pre Requirements
---------------

- Your machine should support virtualization. Sometimes you need to enable it in BIOS.
- OS: Ubuntu or MacOS. Vagrant/Ansible is supported in Windows, but too many hacks.
- Installed VirtualBox+Vagrant+Ansible.
- Internet connection :)

Next steps
---------------

Once you have all of those installed you should:
- Checkout latest Lords code from SVN.
- You should see Vagrantfile in the root of project. Next `cd` to the project's folder and run `vagrant up` in console. This will make Vagrant create Virtual Machine, download Ubuntu image and install it to VM. Next Ansible will be called to install Apache/Php/Mysql/Java etc to VM, fully configure it and start APE (Ajax Push Engine) daemon and AI (Artificial Intelligence) java process. The first launch can take from 5-10 minutes to several hours depending on the internet speed. Be patient.
- Now you have Lords installed inside VM and available from you PC via http://the-lords.org (Vagrant modified your /etc/hosts file).

Other
---------------

- To log into VM run `vagrant ssh`
- To stop VM you should run `vagrant halt` in the project's root folder. To launch VM again run `vagrant up` (it won't install software each time, just once).
- All your files in the project's root are automatically synced with VM's `/var/www/lords` folder. So you can work in IDE on your local machine and all code will be synced to VM.
- To restart Apache: `vagrant ssh` -> `sudo service apache2 restart`.
- To restart APE: `vagrant ssh` -> `killall aped` -> `cd /var/www/lords/ape_scripts/bin` -> `./aped`
- To restart AI: `vagrant ssh` -> `cd /var/www/deployment` -> `./deploy_ai.sh vagrant`
- You can access database on VM via ssh tunnel (https://www.namecheap.com/support/knowledgebase/article.aspx/9330/2180/how-to-connect-to-database-using-workbench-mysql-client). SSH key is stored in project's folder under .vagrant/machines/default/virtualbox/private_key. SSH host is the-lords.org and the user name for SSH connection is vagrant. Database credentials are root/root.

Benefits
---------------

- Quick start for developer
- No manual configuration or installation steps required
- Platform independent - no difference for 32/64 host machine.
