#!/run/current-system/sw/bin/bash

NORMAL_CONFIG="/home/s4m1nd/infra/nix/desktop-pc/gpu-normal.nix"
PASSTHROUGH_CONFIG="/home/s4m1nd/infra/nix/desktop-pc/gpu-passthrough.nix"
NIXOS_CONFIG_DIR="/etc/nixos"
PASSTHROUGH_FLAG="$NIXOS_CONFIG_DIR/gpu-passthrough-enabled"

copy_configs() {
    sudo cp /home/s4m1nd/infra/nix/desktop-pc/*.nix "$NIXOS_CONFIG_DIR/"
}

switch_to_normal() {
    echo "Switching to normal mode..."
    copy_configs
    sudo rm -f "$PASSTHROUGH_FLAG"
    sudo nixos-rebuild switch
    echo "Switched to normal mode. Please reboot for changes to take effect."
}

switch_to_passthrough() {
    echo "Switching to passthrough mode..."
    copy_configs
    sudo touch "$PASSTHROUGH_FLAG"
    sudo nixos-rebuild switch
    echo "Switched to passthrough mode. Please reboot for changes to take effect."
}

case "$1" in
    normal)
        switch_to_normal
        ;;
    passthrough)
        switch_to_passthrough
        ;;
    *)
        echo "Usage: $0 {normal|passthrough}"
        exit 1
        ;;
esac
