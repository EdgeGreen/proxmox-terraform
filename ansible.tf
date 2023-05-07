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
    data.template_file.ansible_playbook,
    local_file.ansible_repo_script
  ]
}

resource "local_file" "ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.module}/ansible/inventory/mycluster/inventory.ini"

  depends_on = [
    null_resource.ansible_repo,
    data.template_file.ansible_inventory
  ]
}

resource "local_file" "ansible_configuration" {
  content  = data.template_file.ansible_configuration.rendered
  filename = "${path.module}/ansible/ansible.cfg"

  depends_on = [
    null_resource.ansible_repo,
    data.template_file.ansible_configuration
  ]
}

resource "null_resource" "ansible_play" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/ansible/inventory/mycluster/inventory.ini  --become --become-user=root ${path.module}/ansible/cluster.yml"
  }

  depends_on = [
    null_resource.ansible_repo,
    local_file.ansible_configuration,
    local_file.ansible_inventory,
    local_file.ansible_repo_script
  ]
}

