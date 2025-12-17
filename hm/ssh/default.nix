{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/S.%r@%h:%p";
        controlPersist = "no";
        extraOptions = {
          ConnectTimeout = "5";
        };
      };
      "ssh.renn.es".extraOptions = {
        "ControlMaster" = "no";
        "ServerAliveInterval" = "60";
        "ServerAliveCountMax" = "10";
      };
      "chorizo issou issou-lan chankla chankla-lan gaspacho" = {
        user = "risitas";
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          }
        ];
      };
      "chorizo issou chankla gaspacho" = {
        proxyCommand = "sh -c 'tunnel check && wgx nc %h %p'";
      };
      "chorizo" = {
        hostname = "10.8.0.1";
        port = 52865;
      };
      "issou".hostname = "10.8.0.3";
      "issou-lan".hostname = "192.168.1.150";
      "chankla".hostname = "10.8.0.2";
      "chankla-lan".hostname = "192.168.1.151";
      "gaspacho".hostname = "192.168.1.153";
      "aur".hostname = "aur.archlinux.org";
      "aur".user = "aur";
      "github.com renn.es git.sr.ht".extraOptions = {
        "ControlPersist" = "1h";
      };
    };
  };
  services.ssh-agent.enable = true;
}
