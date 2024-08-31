resource "proxmox_virtual_environment_vm" "debian-vm-1" {
  name        = var.vm_name
  description = var.vm_desc
  node_name   = var.node
  vm_id       = null  # Let Proxmox choose the VM ID

  agent {
    enabled = true
  }

  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = "host"
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26"  # Linux 2.6+ kernel
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      keys     = [var.ssh_public_key]
      password = null
      username = var.ciuser
    }
  }

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  on_boot = true
}
