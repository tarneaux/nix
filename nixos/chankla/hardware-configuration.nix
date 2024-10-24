# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{ lib, ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3c12dcc2-bdc2-4fd9-b9ee-3a920e65573a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3F97-00D9";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "defaults"
    ];
  };

  fileSystems."/btrfs" = {
    device = "/dev/disk/by-uuid/569a7b5b-6019-49f1-9d98-0d5bdaec353f";
    fsType = "btrfs";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/f384b986-a168-46fd-b510-c8c9b7aea82b"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
