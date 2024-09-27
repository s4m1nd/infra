{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    # Permit root login through SSH
    permitRootLogin = "no";
    # Enable password authentication
    passwordAuthentication = true;
  };

  # Open ports in the firewall for SSH
  networking.firewall.allowedTCPPorts = [ 22 ];
} 
