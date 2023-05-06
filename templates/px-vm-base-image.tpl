#!/bin/bash

imageURL=${px_imageURL}
imageName=${px_imageName}
volumeName=${px_volumeName}
virtualMachineId=${px_virtualMachineId}
templateName=${px_templateName}
tmp_cores=${px_tmp_cores}
tmp_memory=${px_tmp_memory}

rm *.img
wget -O $imageName $imageURL
qm destroy $virtualMachineId
virt-customize -a $imageName --install qemu-guest-agent,openssh-server
qm create $virtualMachineId --name $templateName --memory $tmp_memory --cores $tmp_cores --net0 virtio,bridge=vmbr0
qm importdisk $virtualMachineId $imageName $volumeName
qm set $virtualMachineId --scsihw virtio-scsi-pci --scsi0 $volumeName:vm-$virtualMachineId-disk-0
qm set $virtualMachineId --boot c --bootdisk scsi0
qm set $virtualMachineId --ide2 $volumeName:cloudinit
qm set $virtualMachineId --serial0 socket --vga serial0
qm template $virtualMachineId