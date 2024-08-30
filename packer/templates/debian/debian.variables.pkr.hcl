variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/cdimage/archive/11.10.0/amd64/iso-cd/debian-11.10.0-amd64-netinst.iso"
}

variable "iso_storage_pool" {
  type    = string
}

variable "iso_checksum" {
  type    = string
  default = "sha512:7ef909042308510e42e2da38fa2815e4f39292b07026fc8cf1b12f3148e7329da7d24b01914fc7449895ee08a38f567f1e09c5f7a9bfaa65bb454ebfd0439f91"
}

variable "vmid" {
  type = string
  description = "Proxmox Template ID"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "storage_pool" {
  type    = string
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "network_vlan" {
  type    = string
  default = "10"
}

variable "proxmox_api_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_api_user" {
  type    = string
  default = ""
}

variable "proxmox_host" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "iso_file" {
  type      = string
  default   = "local:iso/debian-11.10.0-amd64-netinst.iso"
}

variable "template_name" {
  type      = string
  default   = "debian-11-cloudinit-template"
}
