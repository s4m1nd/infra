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

provisioner "remote-exec" {
        inline = [
            "echo $(hostname -I | cut -d' ' -f1) > /tmp/vm_ip"
        ]

        connection {
            type        = "ssh"
            user        = var.ciuser
            private_key = file("~/.ssh/id_ed25519")  # Adjust this path to your SSH private key
            host        = self.ssh_host
        }
    }

    provisioner "local-exec" {
        command = "scp -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519 ${var.ciuser}@${self.ssh_host}:/tmp/vm_ip ./vm_ip"
    }
}

data "local_file" "vm_ip" {
    filename = "${path.module}/vm_ip"
    depends_on = [proxmox_vm_qemu.debian-vm-1]
}

output "vm_ip" {
    value = trimspace(data.local_file.vm_ip.content)
}
