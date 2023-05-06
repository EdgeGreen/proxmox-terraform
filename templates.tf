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
