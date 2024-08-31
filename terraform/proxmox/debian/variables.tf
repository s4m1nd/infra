variable "ciuser" {
    type = string
}

variable "memory" {
  type = number
}

variable "cpu_sockets" {
  type = number
}

variable "cpu_cores" {
  type = number
}

variable "clone_template" {
  type        = string
  description = "The name of the template to clone"
}

variable "template_vm_id" {
  type        = number
  description = "The ID of the template VM to clone"
}

variable "vm_desc" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "node" {
  type = string
}
 variable "ssh_public_key" {
  type = string
  description = "SSH public key for VM access"
}

variable "proxmox_api_url" {
  type        = string
  description = "The URL of the Proxmox API"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "The ID of the Proxmox API token"
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "The secret of the Proxmox API token"
  sensitive   = true
}
