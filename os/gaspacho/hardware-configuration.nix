# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{ ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1bd37f7e-dcbf-4bb3-a9cf-17b7a27802d4";
    fsType = "btrfs";
    options = [
      "subvol=@root"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1bd37f7e-dcbf-4bb3-a9cf-17b7a27802d4";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1bd37f7e-dcbf-4bb3-a9cf-17b7a27802d4";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/1bd37f7e-dcbf-4bb3-a9cf-17b7a27802d4";
    fsType = "btrfs";
    options = [
      "subvol=@log"
      "compress=zstd"
      "noatime"
    ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3423-9464";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "defaults"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/0ba0911e-6e2f-46e5-bbd7-23153e054be9"; } ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
