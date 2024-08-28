{ config, lib, pkgs, ... }:

{
  # NVIDIA driver configuration for normal mode
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Keep other non-GPU-specific configurations from your original gpu-passthrough.nix
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    OVMF
    pciutils
    libvirt
    looking-glass-client
    spice-gtk
    win-virtio
    swtpm
  ];

  # services.openssh.enable = true;

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc","/dev/hpet"
    ]
    namespaces = []
  '';

  environment.variables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
}
