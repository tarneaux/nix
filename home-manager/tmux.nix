{ hostname
, pkgs
, ...
}: {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile ./config/tmux.conf;
    prefix = "C-a";
  };
  home.packages = [
    (pkgs.writeScriptBin "__tmux_fzf_window"
      (builtins.readFile ./config/tmux-fzf-window.sh))
  ];
}
