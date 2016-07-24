# ipserver
use ansible to create a FreeIPA server. example using ssh key, install IPA server on a Centos  openstack instance remotely 

Requirements
------------

Primarily tested and functional on centos, openstack instance, but open to others.

************Updates need prior running:*************

	1. enter correct .pem/private key path for ssh with key connction in ansible.cfg 
	
	2. There are 3 in variables that you could provide in vars/private-idm.yml to override default one. this file is in .gitignore will not be checkin. .   

                ipaserver_admin_password  - admin password for freeipa server
                ipaserver_dir_admin_password -Directory Manager password for freeipa server
                migrateSrc_ipa_dir_admin_password - Migrating src directory maanger
        copy vars/private-idm.yml.sample to vars/private-idm.yml and enter default for passwords.
        you might also change the password as run time.


	
	3. update roles/group/all.yml to set default values likes domain name, realm etc.

	4. update hostnames/IPs for each role  in /hosts file

To install IPA Master server:
	ansible-playbook -i hosts -v ipamaster.yml

To Migrate a old IPA server to this ipa master server
	set migrate_enable to True in all.yml 
	ansible-playbook -i hosts -v  --tags migrate ipamaster.yml
To install IPA Replica Server
	ansigle-playbook -i host -v ipaReplica.yml


troubleshoot/lession learned:

after install and reboot, ipactl failed to restart on name server.
Find out hostname was reset back to hostname.novalocal by cloud-init on reboot.
add remove update-hostname in /etc/cloud/cloud.cfg to ipaserver/task/main.yml.
pki tomcat service failed at first ipctl restart after install completed.
further investigation show we need to add 127.0.0.1 hostname.hostdomain back to /etc/hosts after install complete. this is needed to resolve issue with httpd cert is using hostame, and virtual host is expecting 127.0.0.1 in httpd. 
127.0.0.1 should not be exist in /etc/host prior ipa-server install as KDC service will not work with localhost.
updated ansible script to remove 127.0.0.1 entry from  /etc/hosts prior install, and add 127.0.0.1 hostname.hostdomain back to /etc/hosts after ipa-server install.
need to update DNS record to reflect external IP instead of internal IP for the server that are running on openstack instance.



