# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{ lib, ... }:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/28655a0e-5fb1-433a-ac5e-fd48719e9ace";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3D25-8E3D";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" "defaults" ];
    };

  fileSystems."/data" =
    {
      device = "/dev/disk/by-uuid/003b3359-3137-4492-9701-08d416d77aa9";
      fsType = "ext4";
    };

  fileSystems."/hdd" =
    {
      device = "/dev/disk/by-uuid/569a7b5b-6019-49f1-9d98-0d5bdaec353f";
      fsType = "btrfs";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/23b4ea87-b1f5-4fb8-81aa-bfeaa247f81d"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}

