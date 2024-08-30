#!/bin/bash

set -e

# Function to prompt for a value
prompt_for_value() {
    local var_name=$1
    local prompt_text=$2
    local example=$3
    local current_value=${!var_name}

    echo -e "\n$prompt_text"
    echo "Example: $example"
    read -p "Enter value [$current_value]: " user_input
    if [ -n "$user_input" ]; then
        eval "$var_name='$user_input'"
    elif [ -z "$current_value" ]; then
        eval "$var_name='$example'"
    fi
    echo "$var_name set to: ${!var_name}"
}

echo "Setting up Packer configuration..."

# Prompt for vars/debian.pkrvars.hcl values
echo "Configuring vars/debian.pkrvars.hcl"
prompt_for_value proxmox_host "Enter Proxmox host" "13.13.0.129:8006"
prompt_for_value proxmox_node "Enter Proxmox node" "pmx"
prompt_for_value vmid "Enter VMID" "200"
prompt_for_value cpu_type "Enter CPU type" "kvm64"
prompt_for_value cores "Enter number of cores" "2"
prompt_for_value memory "Enter memory in MB" "2048"
prompt_for_value storage_pool "Enter storage pool" "local-lvm"
prompt_for_value disk_size "Enter disk size" "16G"
prompt_for_value disk_format "Enter disk format" "raw"
prompt_for_value network_vlan "Enter network VLAN" "10"
prompt_for_value iso_storage_pool "Enter ISO storage pool" "local:iso"
prompt_for_value iso_file "Enter ISO file" "local:iso/debian-11.10.0-amd64-netinst.iso"

# Write to vars/debian.pkrvars.hcl
echo "Writing to vars/debian.pkrvars.hcl"
cat > vars/debian.pkrvars.hcl <<EOL
proxmox_host      = "${proxmox_host}"
proxmox_node      = "${proxmox_node}"
vmid              = "${vmid}"
cpu_type          = "${cpu_type}"
cores             = "${cores}"
memory            = "${memory}"
storage_pool      = "${storage_pool}"
disk_size         = "${disk_size}"
disk_format       = "${disk_format}"
network_vlan      = "${network_vlan}"
iso_storage_pool  = "${iso_storage_pool}"
iso_file          = "${iso_file}"
EOL

echo "vars/debian.pkrvars.hcl has been updated."

# Prompt for debian.pkrvars.hcl values
echo -e "\nConfiguring debian.pkrvars.hcl"
prompt_for_value proxmox_url "Enter Proxmox URL" "https://13.13.0.129:8006/api2/json"
prompt_for_value proxmox_username "Enter Proxmox username" "root@pam"
prompt_for_value proxmox_password "Enter Proxmox password" "your_password_here"
prompt_for_value proxmox_node_name "Enter Proxmox node name" "pmx"
prompt_for_value template_name "Enter template name" "debian-11-cloudinit-template"
prompt_for_value template_description "Enter template description" "Debian 11 Cloud-Init Template"

# Write to debian.pkrvars.hcl
echo "Writing to debian.pkrvars.hcl"
cat > debian.pkrvars.hcl <<EOL
proxmox_url           = "${proxmox_url}"
proxmox_username      = "${proxmox_username}"
proxmox_password      = "${proxmox_password}"
proxmox_node_name     = "${proxmox_node_name}"
template_name         = "${template_name}"
template_description  = "${template_description}"
EOL

echo "debian.pkrvars.hcl has been updated."

echo "Setup complete. You can now run your Packer commands."
