resource "proxmox_vm_qemu" "wireguard" {
  count       = 1
  name        = "wireguard-${count.index}"

  target_node = "nuc-${count.index}"

  clone = "ubuntu-1804LTS-template"

  os_type  = "cloud-init"
  cores    = 1
  sockets  = "1"
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    id           = 0
    size         = 16
    type         = "scsi"
    storage      = "local"
    storage_type = "directory"
    iothread     = true
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.2.1${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
