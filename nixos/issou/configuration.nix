# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  custom = {
    restic = {
      enable = true;
      paths = [
        "/home/risitas/data"
        "/home/risitas/services"
        "/home/risitas/git/nix"
        "/big/data"
      ];
      exclude = [
        "/home/risitas/data/mastodon/public/system/cache/"
        "/home/risitas/data/mastodon/elasticsearch/"
        "/big/data/mssh/home/tarneo/sync/Films/"
      ];
    };
    networking.ipv4 = {
      lan = "192.168.1.150";
      intra = "10.8.0.3/32";
    };
  };

  systemd.services = {
    nextcloud-cron = {
      path = [ pkgs.docker ];
      script = "docker exec -u 33 nextcloud php cron.php";
      serviceConfig = {
        User = "root";
      };
      startAt = "*:0/5";
    };
    nextcloud-previews = {
      path = [ pkgs.docker ];
      script = "docker exec -u 33 nextcloud php occ preview:pre-generate";
      serviceConfig = {
        User = "root";
      };
      startAt = "*:0/5";
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 7500000;
    "net.core.wmem_max" = 7500000;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
