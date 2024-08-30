#!/bin/bash

set -e

# Function to prompt for a value
prompt_for_value() {
    local var_name=$1
    local prompt_text=$2
    local current_value=${!var_name}

    read -p "$prompt_text [$current_value]: " user_input
    if [ -n "$user_input" ]; then
        eval "$var_name='$user_input'"
    fi
    echo "$var_name set to: ${!var_name}"
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
prompt_for_value proxmox_api_url "Enter Proxmox API URL"
prompt_for_value proxmox_api_token_id "Enter Proxmox API Token ID"
prompt_for_value proxmox_api_token_secret "Enter Proxmox API Token Secret"
prompt_for_value node "Enter target node"
prompt_for_value vm_name "Enter VM name"
prompt_for_value vm_desc "Enter VM description"
prompt_for_value clone_template "Enter clone template name"
prompt_for_value cpu_cores "Enter number of CPU cores"
prompt_for_value cpu_sockets "Enter number of CPU sockets"
prompt_for_value memory "Enter memory in MB"
prompt_for_value ciuser "Enter default user"

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
EOL

echo "credentials.auto.tfvars has been updated."

echo "Setup complete. You can now run your Terraform commands."
