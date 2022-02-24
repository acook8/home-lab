
variable "proxmox_host_node" {
  type    = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_source_template" {
  type = string
}

variable "proxmox_template_name" {
  type    = string
}

variable "proxmox_url" {
  type    = string
}

variable "proxmox_username" {
  type    = string
  default = "root@pam"
}

source "proxmox-clone" "test-cloud-init" {
  insecure_skip_tls_verify = true
  full_clone = false

  template_name = "${var.proxmox_template_name}"
  clone_vm      = "${var.proxmox_source_template}"
  
  os              = "l26"
  cores           = "4"
  memory          = "4096"
  scsi_controller = "virtio-scsi-pci"

  ssh_username = "ubuntu"
  qemu_agent = true

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  ssh_host = "192.168.0.101"

  node          = "${var.proxmox_host_node}"
  username      = "${var.proxmox_username}"
  password      = "${var.proxmox_password}"
  proxmox_url   = "${var.proxmox_url}"
}

build {
  sources = ["source.proxmox-clone.test-cloud-init"]

  provisioner "shell" {
    inline         = ["sudo cloud-init clean",
                      "sleep 20",
                      "sudo apt update -qq",
                      "sudo apt-get install -y nfs-common open-iscsi qemu-guest-agent",
                      "sudo snap install microk8s --classic"
                      ]
  }
}