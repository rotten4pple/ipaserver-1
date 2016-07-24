echo "ensure migrate_enable is set to true in group_vars/all.yml
ansible-playbook -i hosts -v  --tags migrate ipamaster.yml 

