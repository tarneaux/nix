{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/S.%r@%h:%p";
        controlPersist = "no";
        connectTimeout = "5";
      };
      "ssh.renn.es" = {
        "ControlMaster" = "no";
        "ServerAliveInterval" = "60";
        "ServerAliveCountMax" = "10";
      };
      "issou issou-lan chankla chankla-lan" = {
        forwardAgent = true;
        RemoteForward = {
          bind.address = "/run/user/1000/gnupg/S.gpg-agent";
          host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
        };
      };
      "issou issou-lan chankla chankla-lan paella" = {
        user = "risitas";
      };
      "issou chankla" = {
        proxyJump = "jolly@paella";
      };
      "paella" = {
        hostname = "51.210.247.8";
        port = 52865;
      };
      "issou".hostname = "10.10.0.3";
      "issou-lan".hostname = "192.168.1.150";
      "chankla".hostname = "10.10.0.2";
      "chankla-lan".hostname = "192.168.1.151";
      "github.com renn.es git.sr.ht" = {
        "ControlPersist" = "1h";
      };
    };
  };
  services.ssh-agent.enable = true;
}
