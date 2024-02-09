# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{...}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fe96a3ab-2fe4-47b2-8238-a9afebd4a540";
    fsType = "btrfs";
    options = ["subvol=@root" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/fe96a3ab-2fe4-47b2-8238-a9afebd4a540";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/fe96a3ab-2fe4-47b2-8238-a9afebd4a540";
    fsType = "btrfs";
    options = ["subvol=@nix" "compress=zstd" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/fe96a3ab-2fe4-47b2-8238-a9afebd4a540";
    fsType = "btrfs";
    options = ["subvol=@persist" "compress=zstd" "noatime"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/fe96a3ab-2fe4-47b2-8238-a9afebd4a540";
    fsType = "btrfs";
    options = ["subvol=@log" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9513-F653";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077" "defaults"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/454ba952-54ba-4641-b7f1-85abe700a2db";}
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
