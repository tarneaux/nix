{ ... }:
{
  programs.irssi = {
    enable = true;
    networks = {
      libera = {
        nick = "tarneo";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
        channels = {
          nixos.autoJoin = true;
        };
      };
      oftc = {
        nick = "tarneo";
        server = {
          address = "irc.oftc.net";
          port = 6697;
          autoConnect = true;
        };
        channels = {
        };
      };
      freenode = {
        nick = "tarneo";
        server = {
          address = "irc.freenode.net";
          port = 6697;
          autoConnect = true;
        };
        channels = {
          zettelkasten.autoJoin = true;
        };
      };
    };
  };
}
