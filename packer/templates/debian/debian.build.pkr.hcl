build {
  sources = ["source.proxmox-iso.debian-11"]

  # Using ansible playbooks to configure debian
  provisioner "ansible" {
    playbook_file    = "./ansible/debian_config.yml"
    use_proxy        = false
    user             = var.ssh_username
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "ansible_password=${var.ssh_password}"]
  }

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "debian/http/cloud.cfg"
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "debian/http/99-pve.cfg"
  }
}
