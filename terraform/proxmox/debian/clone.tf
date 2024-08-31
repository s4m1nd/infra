resource "proxmox_vm_qemu" "debian-vm-1" {
    
    target_node = var.node # "pmx"
    # vmid = "100"
    name = var.vm_name # "debian-vm-1"
    desc = var.vm_desc # "debian server"

    onboot = true 

    clone = var.clone_template # "pckr-tmpl-debian-11"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = var.cpu_cores # 1
    sockets = var.cpu_sockets # 1
    cpu = "host"
    
    # VM Memory Settings
    memory = var.memory # 2048

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"
    ipconfig0 = "ip=dhcp"
    ciuser = var.ciuser # s4m1nd
    sshkeys = var.ssh_public_key 
}

