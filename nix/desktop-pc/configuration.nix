# configuration.nix
{ config, pkgs, lib, ... }:
let
  gpuConfig = if builtins.pathExists /etc/nixos/gpu-passthrough-enabled
              then ./gpu-passthrough.nix
              else ./gpu-normal.nix;
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./user.nix
      ./ssh.nix
      gpuConfig
    ];

  # Bootloader configuration (unchanged)
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      splashImage = "/boot/grub/iubita2.jpg";
      configurationLimit = 5;
      gfxmodeEfi = "1920x1080";
    };
  };

  boot.initrd.luks.devices."luks-6f074e2d-2789-4c08-b7e1-bb2b64602811".device 
    = "/dev/disk/by-uuid/6f074e2d-2789-4c08-b7e1-bb2b64602811"; 

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    bridges = {
      vmbr0 = {
        interfaces = [  ];
      };
    };
    interfaces.vmbr0 = {
      ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };
    nat = {
      enable = true;
      externalInterface = "eno1";
      internalInterfaces = [ "vmbr0" ];
    };
    firewall = {
      enable = true;
      # allowedTCPPorts = [ 3389 ];  # for RDP
      allowedTCPPorts = [ 3389 ] ++ (lib.range 5900 5909);  # RDP and VNC ports 
      extraCommands = ''
        iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
        iptables -A FORWARD -i vmbr0 -o eno1 -j ACCEPT
        iptables -A FORWARD -i eno1 -o vmbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -t nat -A PREROUTING -p tcp --dport 3389 -j DNAT --to-destination 192.168.100.144:3389
        iptables -t nat -A PREROUTING -p tcp --dport 5900:5909 -j DNAT --to-destination 192.168.100.145 
      '';
    };
  };

  # Time zone and locale settings (unchanged)
  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # X11 and desktop environment configuration
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Resolve SSH askPassword conflict
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  # Enable CUPS for printing
  services.printing.enable = true;

  # Sound configuration
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    os-prober
  ];

  # Enable additional services for better integration
  services.gnome.core-utilities.enable = true;
  services.picom.enable = true;
  services.autorandr.enable = true;

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "vmbr0";
      bind-interfaces = true;
      dhcp-range = "192.168.100.50,192.168.100.150,12h";
      except-interface = "virbr0";  # Exclude libvirt's default network
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "24.05";
}
