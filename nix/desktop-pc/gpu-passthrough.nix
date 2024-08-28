{ config, lib, pkgs, ... }:

let
  gpuIDs = [
    "10de:1b80" # NVIDIA GeForce GTX 1080
    "10de:10f0" # NVIDIA GP104 High Definition Audio Controller
  ];
in
{
  # Kernel parameters for IOMMU and VFIO
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=${builtins.concatStringsSep "," gpuIDs}"
    "default_hugepagesz=2M"
    "hugepagesz=2M"
    "hugepages=4096"
  ];

  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 4096;
  };

  # Load required modules
  # boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  boot.kernelModules = [ "kvm-intel" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  # Blacklist NVIDIA drivers for the GPU to be passed through
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];

  # NVIDIA driver configuration (for other NVIDIA GPUs if present)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # QEMU/KVM configuration
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  # CPU governor settings for better VM performance
  powerManagement.cpuFreqGovernor = "performance";


  # VFIO permissions
  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  # User configuration
  users.users.s4m1nd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "input" "disk" "usb" ];
  };

  # Install necessary packages
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

  # Enable SSH for remote access
  # services.openssh.enable = true;

  # If you're using GNOME, enable necessary services
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Optional: CPU pinning for better VM performance
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc","/dev/hpet"
    ]
    namespaces = []
  '';

  # System-wide environment variables
  environment.variables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
}
