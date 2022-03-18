resource "proxmox_vm_qemu" "microk8s-master" {
  count             = 1
  name              = "microk8s-master"
  target_node       = "proxmox"

  clone             = "k8s-base"

  os_type           = "cloud-init"
  cores             = 4
  sockets           = "1"
  cpu               = "host"
  memory            = 4096
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"

  disk {
    # id              = 0
    size            = "70G"
    type            = "scsi"
    storage         = "local-lvm"
    # storage_type    = "lvm"
    iothread        = 1
  }

  network {
    # id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ciuser            = "acook8"
  ipconfig0         = "ip=192.168.0.120/24,gw=192.168.0.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "microk8s-agent" {
  count             = 2
  name              = "microk8s-node-${count.index}"
  target_node       = "proxmox"

  clone             = "k8s-base"

  os_type           = "cloud-init"
  cores             = 4
  sockets           = "1"
  cpu               = "host"
  memory            = 4096
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"

  disk {
    # id              = 0
    size            = "70G"
    type            = "scsi"
    storage         = "local-lvm"
    # storage_type    = "lvm"
    iothread        = 1
  }

  network {
    # id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ciuser = "acook8"
  ipconfig0         = "ip=192.168.0.12${count.index + 1}/24,gw=192.168.0.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
