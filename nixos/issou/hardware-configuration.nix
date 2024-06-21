# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{ ... }: {
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bb7aea03-2703-4616-b936-084fc29cbce6";
    fsType = "btrfs";
    options = [ "subvol=@root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bb7aea03-2703-4616-b936-084fc29cbce6";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bb7aea03-2703-4616-b936-084fc29cbce6";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/bb7aea03-2703-4616-b936-084fc29cbce6";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/bb7aea03-2703-4616-b936-084fc29cbce6";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" "defaults" ];
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-uuid/c7df6f0d-afe5-4bc2-8aa2-af9008c85e05";
    fsType = "btrfs";
    options = [ "subvol=/" "compress=zstd" "noatime" ];
  };

  swapDevices = [
    { device = "/dev/nvme0n1p2"; }
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
