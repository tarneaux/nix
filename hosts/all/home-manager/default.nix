{ hostname, username, ... }:

{
  imports = [
    ../../${hostname}/home-manager.nix
  ];
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
  };

  programs.git = {
    enable = true;
    userName = "server";
    userEmail = "server@renn.es";
    aliases = {
      ga = "git add";
      gap = "git add --patch";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit -a";
      gcam = "git commit -am";
      gp = "git push";
      gs = "git status";
      gl = "git log --decorate --oneline --graph";
      gd = "git diff";
      gb = "git branch";
      gco = "git checkout";
    };
  };

  programs.home-manager.enable = true;
}
