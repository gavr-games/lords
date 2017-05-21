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
- You should see Vagrantfile in the root of project. Next `cd` to the project's folder and run `vagrant up` in console. This will make Vagrant create Virtual Machine, download Ubuntu image and install it to VM. Next Ansible will be called to install Apache/Php/Mysql/Java etc to VM and fully configure it. The first launch can take from 5 to 10 minutes. Pe patient.
- Now you have Lords installed inside VM and available from you PC via http://the-lords.org (Vagrant modified your /etc/hosts file).
- Next you need to login to VM and launch Ape and AI daemons. To login run `vagrant ssh`
- Once you are logged in, go to `cd /var/www/lords/ape_scripts/bin` and run `./aped`. This will start APE (Ajax Push Engine) daemon.
- Launch AI on Java, go to `cd /var/www/deployment` and run `./deploy_ai.sh vagrant`. It will copy sources to tmp and compile them there and launch.
- Now you have working local copy of Lords on VM. Open browser on your computer and go to `http://the-lords.org`.

Other
---------------

- To stop VM you should run `vagrant halt` in the project's root folder. To launch VM again run `vagrant up` (it won't install software each time, just once).
- All your files in the project's root are automatically synced with VM's `/var/www/lords` folder. So you can work in IDE on your local machine and all code will be synced to VM.
- You should launch APE and AI daemons manually each time you bring VM up. I was lazy to make them autostarted :(
- To restart Apache: `vagrant ssh` -> `sudo service apache2 restart`.
- To restart APE: `vagrant ssh` -> `killall aped` -> `cd /var/www/lords/ape_scripts/bin` -> `./aped`
- To restart AI: `vagrant ssh` -> `cd /var/www/deployment` -> `./deploy_ai.sh vagrant`
- You can access database on VM via ssh tunnel (https://www.namecheap.com/support/knowledgebase/article.aspx/9330/2180/how-to-connect-to-database-using-workbench-mysql-client). SSH key is stored in project's folder under .vagrant/machines/default/virtualbox/private_key. SSH host is the-lords.org.

Benefits
---------------

- Quick start for developer
- No manual configuration or installation steps required
- Platform independent - no difference for 32/64 host machine.
