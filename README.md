# ipserver
use ansible to create a FreeIPA server. example using ssh key, install IPA server on a Centos  openstack instance remotely 

Requirements
------------

Primarily tested and functional on centos, openstack instance, but open to others.

************Updates need prior running:*************

	1. enter correct .pem/private key path for ssh with key connction in ansible.cfg 
	

	2. There are 2 main variables that need to be provided external to the role that have no default. 

    		ipaserver_admin_password
    		ipaserver_dir_admin_password
	copy vars/private-idm.yml.sample to vars/private-idm.yml and enter default for passwords.
	you might also change the password as run time.

	3. update hostname/IP in hosts file

To install IPA Master server
	ansible-playbook -i hosts -v ipamaster.yml

troubleshoot/lession learned:
after install, ipactl restart failed on name server.
find out hostname was reset back to hostname.novalocal by cloud-init.
remove update-hostname in /etc/cloud/cloud.cfg, it's now part of ansible script.
pki tomcat service failed to restart after install completed, and first ipactl restart.
need to add 127.0.0.1 hostname.hostdomain back to /etc/hosts after install complete, to resolve issue with httpd cert is using hostame, and virtual host is expecting 127.0.0.1 in httpd. 
127.0.0.1 should not be exist in /etc/host prior ipa-server install as KDC service will not work with localhost.
updated ansible script to remove 127.0.0.1 entry from  /etc/hosts prior install, and add 127.0.0.1 hostname.hostdomain back to /etc/hosts after ipa-server install.
need to update DNS record to reflect external IP instead of internal IP for the server that are running on openstack instance.

