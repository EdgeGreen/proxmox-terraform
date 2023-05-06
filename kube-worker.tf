resource "proxmox_vm_qemu" "kube_worker_node" {
  count = 3

  name = "kube-workes-node-${count.index + 1}"
  desc = "kube-workes-node-${count.index + 1}"
  vmid = "33${count.index + 1}"

  qemu_os = "l26"
  bios    = "seabios"
  onboot  = true

  target_node = "edge-green"
  os_type     = "cloud-init"
  full_clone  = true
  clone       = "px-base-ubuntu-22"

  sockets = 1
  cores   = 1
  memory  = 4096

  ssh_user   = "ubuntu"
  sshkeys    = tls_private_key.px_vm_key.public_key_openssh
  ciuser     = "ubuntu"
  cipassword = "ubuntu"

  ipconfig0 = "ip=dhcp"
  # nameserver       = "8.8.8.8 127.0.0.1"

  automatic_reboot = true
  agent            = 1

  disk {
    storage = "Hard"
    type    = "virtio"
    size    = "32G"
  }

  network {
    bridge   = "vmbr0"
    model    = "virtio"
    mtu      = 0
    macaddr  = "02:07:14:b4:37:3${count.index + 1}"
    queues   = 0
    rate     = 0
    firewall = false
  }

  depends_on = [
    tls_private_key.px_vm_key,
    null_resource.vm_base_image
  ]

  lifecycle {
    ignore_changes = [
      # After a reboot, this swaps as it begins owning it's own disk ontop of the template
      full_clone,
      define_connection_info,
      disk,
    ]
  }
}
