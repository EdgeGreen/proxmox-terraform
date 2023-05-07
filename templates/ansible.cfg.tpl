[ssh_connection]
pipelining=True
ansible_ssh_args = -o ControlMaster=auto -o ControlPersist=30m -o ConnectionAttempts=100 -o UserKnownHostsFile=/dev/null

[defaults]
remote_user = ${an_ssh_user}
private_key_file = ${an_ssh_key_path}
host_key_checking=False
inventory = inventory/my-cluster/hosts.ini

force_valid_group_names = ignore
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp
fact_caching_timeout = 86400
stdout_callback = default
display_skipped_hosts = no

