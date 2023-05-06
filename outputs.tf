output "proxmox_ip_address_kube_master_nodes" {
  description = "Current IPv4 kube-master nodes"
  value       = proxmox_vm_qemu.kube_master_node.*.default_ipv4_address
}

output "proxmox_ip_address_kube_worker_nodes" {
  description = "Current IPv4 kube-workes nodes"
  value       = proxmox_vm_qemu.kube_worker_node.*.default_ipv4_address
}
