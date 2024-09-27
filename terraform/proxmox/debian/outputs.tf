output "vm_ip_address" {
  value = length(proxmox_virtual_environment_vm.debian-vm-1.ipv4_addresses) > 0 && length(proxmox_virtual_environment_vm.debian-vm-1.ipv4_addresses[0]) > 0 ? proxmox_virtual_environment_vm.debian-vm-1.ipv4_addresses[0][0] : "IP not available yet"
  description = "The IP address of the deployed VM"
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.debian-vm-1.name
  description = "The name of the deployed VM"
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.debian-vm-1.vm_id
  description = "The ID of the deployed VM"
}
