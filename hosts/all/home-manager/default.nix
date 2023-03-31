{ pkgs, hostname, username, ... }:

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
      a = "add";
      ap = "add --patch";
      c = "commit";
      cm = "commit -m";
      ca = "commit -a";
      cam = "commit -am";
      p = "push";
      s = "status";
      l = "log --decorate --oneline --graph";
      d = "diff";
      b = "branch";
      co = "checkout";
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";
    history = {
      extended = true;
      ignoreDups = true;
      share = true;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      { plugin = gruvbox;
        config = "colorscheme gruvbox";
      }
    ];
  };

  programs.home-manager.enable = true;
}
