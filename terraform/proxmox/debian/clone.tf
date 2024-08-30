resource "proxmox_vm_qemu" "debian-vm-1" {
    
    target_node = "pmx"
    # vmid = "100"
    name = "debian-vm-1"
    desc = "debian server"

    onboot = true 

    clone = "pckr-tmpl-debian-11"

    # VM System Settings
    agent = 1
    
    # VM CPU Settings
    cores = 1
    sockets = 1
    cpu = "host"    
    
    # VM Memory Settings
    memory = 2048

    # VM Network Settings
    network {
        bridge = "vmbr0"
        model  = "virtio"
    }

    # VM Cloud-Init Settings
    os_type = "cloud-init"

    # (Optional) IP Address and Gateway
    ipconfig0 = "ip=dhcp"
    
    # (Optional) Default User
    ciuser = "s4m1nd"
    
    # (Optional) Add your SSH KEY
    sshkeys = <<EOF
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0M4k8rPNVJjDhEsUpGjzEms3DHixD0jdGHQW7Ee1W7BjygEdsPkJWPiqZShzR8dsOTYpDHYF4wpcVyfVkBQ/2tnecC6CQGSQmyT/zjPSGWn7mF5R6R/xBjYF5TpSLm+fR26lCqdJJNXPJVHQxVsvuS2OJMrKzJbmA7LGzG2HB01T5Je6rWDDBGmGmgGOrxaHWWhxyQl1XdYPAlli3vHbEcrydyOZvs1z+2vFZ+29WFR/peRIVmTULssr0RNZ3+XsFk2FqdVZygMjC7PFBKk77KVPNUdB6qHsCjlbkctJ4laxqVC5k3qqEpUQmtpkFos9kHaWiMrVywAXvcq+tj4PRaNN2v+32OeC8KsWEEDGd/8UZR/2LEFvmo99ER3u2Uy2A5Rque1zQEgvWd07+DP4oh7WmHa7qlgD+ieZm41Ark8fpra24igiigogZrJWc+6ec+QDB4tQgJeQL/BQZp0b+WObiwiJDZDFsbjMZ77SynONWEG/sllUMVpeG08pbABRo1qNGCkpfGYw3kMJ7+TM7vIvGAUkz6iNme0qS85vgSTOA7LtIAGs04/uwp/hTthFv0ogqcF5ZNgZlyNee1dFEGveFHrqel33MsUZn6fwi4WkWZSlp4gbjt0n43i9H1OpLMM4Ug85li5QCQcfI0Pr7OgWkikmSstnxGlc9SYdnxQ== s4m1nd@raspberrypi
    EOF
}
