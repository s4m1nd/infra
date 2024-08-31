#!/bin/bash
set -e

# Function to prompt for a value
prompt_for_value() {
    local var_name=$1
    local prompt_text=$2
    local current_value=${!var_name}
    local default_value=$3

    if [ -z "$current_value" ]; then
        current_value=$default_value
    fi

    read -p "$prompt_text [$current_value]: " new_value
    if [ -z "$new_value" ]; then
        eval "$var_name='$current_value'"
    else
        eval "$var_name='$new_value'"
    fi
}

# Function to read values from credentials.auto.tfvars
read_credentials() {
    if [ -f credentials.auto.tfvars ]; then
        echo "Reading existing values from credentials.auto.tfvars"
        while IFS='=' read -r key value; do
            key=$(echo $key | xargs)
            value=$(echo $value | xargs | sed 's/^"//;s/"$//')
            if [ -n "$key" ] && [ -n "$value" ]; then
                eval "$key='$value'"
                echo "Read $key: $value"
            fi
        done < credentials.auto.tfvars
    else
        echo "credentials.auto.tfvars not found. Starting with empty values."
    fi
}

# Read existing values
read_credentials

# Prompt for all values
echo "Please enter values for all fields. Press Enter to keep existing value (shown in brackets)."

prompt_for_value proxmox_api_url "Enter Proxmox API URL" "https://13.13.0.129:8006/api2/json"
prompt_for_value proxmox_api_token_id "Enter Proxmox API Token ID" "terraform-prov@pve!prov"
prompt_for_value proxmox_api_token_secret "Enter Proxmox API Token Secret" "secret"
prompt_for_value node "Enter target node" "pmx"
prompt_for_value vm_name "Enter VM name" "vm-1"
prompt_for_value vm_desc "Enter VM description" "desc"
prompt_for_value clone_template "Enter clone template name" "debian-11-cloudinit-template"
prompt_for_value cpu_cores "Enter number of CPU cores" "1"
prompt_for_value cpu_sockets "Enter number of CPU sockets" "1"
prompt_for_value memory "Enter memory in MB" "2048"
prompt_for_value ciuser "Enter default user" "root"
prompt_for_value ssh_public_key "Enter SSH public key" ""

# Update credentials.auto.tfvars with new values
echo "Updating credentials.auto.tfvars"
cat > credentials.auto.tfvars <<EOL
proxmox_api_url = "${proxmox_api_url}"
proxmox_api_token_id = "${proxmox_api_token_id}"
proxmox_api_token_secret = "${proxmox_api_token_secret}"
node = "${node}"
vm_name = "${vm_name}"
vm_desc = "${vm_desc}"
clone_template = "${clone_template}"
cpu_cores = ${cpu_cores}
cpu_sockets = ${cpu_sockets}
memory = ${memory}
ciuser = "${ciuser}"
ssh_public_key = "${ssh_public_key}"
EOL

echo "credentials.auto.tfvars has been updated."
echo "Setup complete. You can now run your Terraform commands."
