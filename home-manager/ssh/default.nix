{ ... }:
{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPath = "~/.ssh/S.%r@%h:%p";
    controlPersist = "no";
    extraOptionOverrides = {
      ConnectTimeout = "5";
    };
    matchBlocks = {
      "ssh.renn.es" = {
        extraOptions = {
          "ControlMaster" = "no";
        };
      };
      "aur" = {
        hostname = "aur.archlinux.org";
        user = "aur";
      };
      "chorizo chorizo-v issou issou-v chankla gaspacho" = {
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          }
        ];
        user = "risitas";
      };
      "chorizo" = {
        hostname = "51.210.180.14";
        port = 52865;
      };
      "chorizo-v" = {
        hostname = "10.8.0.1";
        port = 52865;
      };
      "issou" = {
        hostname = "192.168.1.150";
      };
      "issou-v" = {
        hostname = "10.8.0.3";
      };
      "chankla" = {
        hostname = "10.8.0.2";
      };
      "gaspacho" = {
        hostname = "192.168.1.153";
      };
    };
  };
}
