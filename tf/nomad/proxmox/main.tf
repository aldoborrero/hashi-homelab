resource "proxmox_vm_qemu" "nomad_server" {
  count       = 3
  name        = "nomad-server-${count.index}"

  target_node = "nuc-${count.index}"

  clone = "ubuntu-1804LTS-template"

  os_type  = "cloud-init"
  cores    = 4
  sockets  = "1"
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  agent = true

  disk {
    id           = 0
    size         = 20
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
  ipconfig0 = "ip=192.168.1.1${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "nomad_client" {
  count       = 3
  name        = "nomad-${count.index}"

  target_node = "nuc-${count.index}"

  clone = "ubuntu-1804LTS-template"

  os_type  = "cloud-init"
  cores    = 4
  sockets  = "1"
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    id           = 0
    size         = 20
    type         = "scsi"
    storage      = "data2"
    storage_type = "lvm"
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
  ipconfig0 = "ip=192.168.2.12${count.index + 1}/24,gw=192.168.1.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
