# https://www.norocketscience.at/blog/terraform/deploy-proxmox-virtual-machines-using-cloud-init
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
qm create 9000 --name "ubuntu-1804-cloudinit-template" --memory 2048 --net0 virtio,bridge=vmbr0
mv bionic-server-cloudimg-amd64.img bionic-server-cloudimg-amd64.qcow2
qm importdisk 9000 bionic-server-cloudimg-amd64.qcow2 local-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
qm template 9000
