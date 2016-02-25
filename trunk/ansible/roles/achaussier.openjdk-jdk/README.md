openjdk-jdk
===========

[![Build Status](https://travis-ci.org/infOpen/ansible-role-openjdk-jdk.svg?branch=master)](https://travis-ci.org/infOpen/ansible-role-openjdk-jdk)

Install openjdk-jdk package.

Today, this role used default config files from system packages. I'll take time
later to generate templates if necessary, or accept pull requests ;)

Requirements
------------

This role requires Ansible 1.5 or higher, and platform requirements are listed
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

    openjdk_jdk_package_state : present
    openjdk_jdk_version : 7

Debian family specific vars

    openjdk_jdk_packages :
      - "openjdk-{{ openjdk_jdk_version }}-jdk" }}"

Dependencies
------------

None

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: achaussier.openjdk-jdk }

License
-------

MIT

Author Information
------------------

Alexandre Chaussier (for Infopen company)
- http://www.infopen.pro
- a.chaussier [at] infopen.pro } }}"

