resource "local_file" "ansible_repo_script" {
  file_permission = "0700"
  content         = data.template_file.ansible_playbook.rendered
  filename        = "${path.module}/templates/ansible_playbook.sh"

  depends_on = [
    data.template_file.ansible_playbook,
  ]
}

resource "null_resource" "ansible_repo" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "${path.module}/templates/ansible_playbook.sh"
  }

  depends_on = [
    local_file.ansible_repo_script
  ]
}

resource "local_file" "ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/ansible/inventory/my-cluster/hosts.ini"

  depends_on = [
    null_resource.ansible_repo,
  ]
}

resource "local_file" "ansible_configuration" {
  content  = data.template_file.ansible_configuration.rendered
  filename = "${path.module}/ansible/ansible.cfg"

  depends_on = [
    local_file.ansible_inventory
  ]
}

resource "local_file" "ansible_vars" {
  content  = data.template_file.ansible_vars.rendered
  filename = "${path.module}/ansible/inventory/my-cluster/group_vars/all.yml"

  depends_on = [
    local_file.ansible_configuration,
  ]
}

resource "null_resource" "ansible_play" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/ansible && ansible-playbook site.yml -i inventory/my-cluster/hosts.ini"
  }

  depends_on = [
    null_resource.ansible_repo,
    local_file.ansible_configuration,
    local_file.ansible_inventory,
    local_file.ansible_repo_script,
    local_file.ansible_vars
  ]
}

resource "null_resource" "kube_config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "scp -i ${path.module}/.ssh/key ubuntu@${proxmox_vm_qemu.kube_master_node[0].default_ipv4_address}:~/.kube/config ~/config"
  }

  depends_on = [
    null_resource.ansible_play
  ]
}

