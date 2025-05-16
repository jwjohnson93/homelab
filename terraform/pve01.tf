resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = "terraform-test"
  target_node = "pve01"
  vmid        = null # Let Proxmox auto-assign, or set a specific ID if desired
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  boot        = "order=ide2;scsi0"

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  disk {
    slot    = "scsi0"
    size    = "32G"
    type    = "disk"
    storage = "local-zfs"
  }

  disk {
    slot    = "ide2"
    type    = "cdrom"
    storage = "local"
    # The ISO must be present in the Proxmox storage 'local' under the 'iso' directory
    # The provider will attach the latest ISO if multiple are present
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type = "cloud-init"
  agent   = 1

  # Optional: Add cloud-init config here if you want automatic login, ssh keys, etc.
  # ciuser     = "ubuntu"
  # cipassword = "yourpassword"
  # sshkeys    = file("~/.ssh/id_rsa.pub")
}
