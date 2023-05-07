[master]
${px_node_1}  
${px_node_2}  
${px_node_3}

[node]
${px_node_4}  
${px_node_5}
${px_node_6} 

# only required if proxmox_lxc_configure: true
# must contain all proxmox instances that have a master or worker node
# [proxmox]
# 192.168.xx.xx

[k3s_cluster:children]
master
node
