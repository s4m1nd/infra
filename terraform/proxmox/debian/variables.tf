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
  type = string
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
