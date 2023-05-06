resource "tls_private_key" "px_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "px_vm_key_local" {
  directory_permission = "0700"
  file_permission      = "0600"
  sensitive_content    = tls_private_key.px_vm_key.private_key_pem
  filename             = "${path.module}/.ssh/key"
}
