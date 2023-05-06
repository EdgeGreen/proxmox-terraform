resource "null_resource" "vm_base_image" {
  #   triggers = {
  #     always_run = "${timestamp()}"
  #   }

  connection {
    type     = "ssh"
    user     = var.px_ssh_info.user
    password = var.px_ssh_info.password
    host     = var.px_ssh_info.host
  }

  provisioner "file" {
    content     = data.template_file.px-base-ubuntu.rendered
    destination = "/tmp/px-vm-base-image.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/px-vm-base-image.sh",
      "/tmp/px-vm-base-image.sh",
    ]
  }
}
