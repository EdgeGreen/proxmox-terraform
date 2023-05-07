data "template_file" "px-base-ubuntu" {
  template = file("${path.module}/templates/px-vm-base-image.tpl")
  vars = {
    px_imageURL         = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
    px_imageName        = "jelly-live-server-amd64.img"
    px_volumeName       = "local-lvm"
    px_virtualMachineId = "9012"
    px_templateName     = "px-base-ubuntu-22"
    px_tmp_cores        = "2"
    px_tmp_memory       = "4096"
  }
}

data "template_file" "ansible_playbook" {
  template = file("${path.module}/templates/ansible_playbook.sh.tpl")
  vars = {
    an_folder_path = "${path.module}/ansible"
    an_git_link    = "https://github.com/techno-tim/k3s-ansible.git"
  }

  depends_on = [
    proxmox_vm_qemu.kube_master_node,
    proxmox_vm_qemu.kube_worker_node,
  ]
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/templates/ansible_inventory.ini.tpl")
  vars = {
    px_node_1 = proxmox_vm_qemu.kube_master_node[0].default_ipv4_address
    px_node_2 = proxmox_vm_qemu.kube_master_node[1].default_ipv4_address
    px_node_3 = proxmox_vm_qemu.kube_master_node[2].default_ipv4_address
    px_node_4 = proxmox_vm_qemu.kube_worker_node[0].default_ipv4_address
    px_node_5 = proxmox_vm_qemu.kube_worker_node[1].default_ipv4_address
    px_node_6 = proxmox_vm_qemu.kube_worker_node[2].default_ipv4_address
  }

  depends_on = [
    proxmox_vm_qemu.kube_master_node,
    proxmox_vm_qemu.kube_worker_node,
    data.template_file.ansible_playbook
  ]
}

data "template_file" "ansible_vars" {
  template = file("${path.module}/templates/ansible_vars.yml.tpl")
  vars = {
    an_ssh_user             = "ubuntu"
    system_timezone         = "Europe/Kiev"
    apiserver_endpoint      = "192.168.33.222"
    k3s_token               = "some-SUPER-DEDEUPER-secret-password"
    metal_lb_ip_range_start = "192.168.33.160"
    metal_lb_ip_range_end   = "192.168.33.180"
  }

  depends_on = [
    proxmox_vm_qemu.kube_master_node,
    proxmox_vm_qemu.kube_worker_node,
    data.template_file.ansible_playbook
  ]
}

data "template_file" "ansible_configuration" {
  template = file("${path.module}/templates/ansible.cfg.tpl")
  vars = {
    an_ssh_user     = "ubuntu"
    an_ssh_key_path = "../.ssh/key"
  }

  depends_on = [
    data.template_file.ansible_playbook
  ]
}
