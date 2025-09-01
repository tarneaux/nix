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
      "ssh.renn.es".extraOptions = {
        "ControlMaster" = "no";
        "ServerAliveInterval" = "60";
        "ServerAliveCountMax" = "10";
      };
      "chorizo issou issou-lan chankla gaspacho" = {
        user = "risitas";
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          }
        ];
      };
      "chorizo" = {
        hostname = "10.8.0.1";
        port = 52865;
      };
      "issou".hostname = "10.8.0.3";
      "issou-lan".hostname = "192.168.1.150";
      "chankla".hostname = "10.8.0.2";
      "gaspacho".hostname = "192.168.1.153";
      "aur".hostname = "aur.archlinux.org";
      "aur".user = "aur";
      "github.com renn.es git.sr.ht".extraOptions = {
        "ControlPersist" = "1h";
      };
    };
  };
}
