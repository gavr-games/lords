openjdk-jre
===========

[![Build Status](https://travis-ci.org/infOpen/ansible-role-openjdk-jre.svg?branch=master)](https://travis-ci.org/infOpen/ansible-role-openjdk-jre)

Install openjdk-jre package.

Requirements
------------

This role requires Ansible 1.4 or higher, and platform requirements are listed
in the metadata file.

Testing
-------

This role has two test methods :

- localy with Vagrant :
    vagrant up

- automaticaly by Travis

Vagrant should be used to check the role before push changes to Github.

Role Variables
--------------

Follow the possible variables with their default values

    # Package variables
    #------------------
    openjdk_jre_package_state  : present

    openjdk_jre_version : 7


Specific OS family vars :

    # Debian
    openjdk_jre_packages :
      - "openjdk-{{ openjdk_jre_version }}-jre"

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: infOpen.openjdk-jre }

License
-------

MIT

Author Information
------------------

Alexandre Chaussier (for Infopen company)
- http://www.infopen.pro
- a.chaussier [at] infopen.pro
