# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
node1 ansible_host=${px_node_1}  # ip=10.3.0.1 etcd_member_name=etcd1
node2 ansible_host=${px_node_2}  # ip=10.3.0.2 etcd_member_name=etcd2
node3 ansible_host=${px_node_3}  # ip=10.3.0.3 etcd_member_name=etcd3
node4 ansible_host=${px_node_4}  # ip=10.3.0.4 etcd_member_name=etcd4
node5 ansible_host=${px_node_5}  # ip=10.3.0.5 etcd_member_name=etcd5
node6 ansible_host=${px_node_6}  # ip=10.3.0.6 etcd_member_name=etcd6

# ## configure a bastion host if your nodes are not directly reachable
# [bastion]
# bastion ansible_host=x.x.x.x ansible_user=some_user

[kube_control_plane]
node1
node2
node3

[etcd]
node1
node2
node3

[kube_node]
node4
node5
node6

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
