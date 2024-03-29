{ hostname
, pkgs
, ...
}: {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile ./config/tmux.conf;
    prefix =
      if hostname == "framy"
      then "C-a"
      else "C-b";
  };
  home.packages = [
    (pkgs.writeScriptBin "__tmux_fzf_window"
      (builtins.readFile ./config/tmux-fzf-window.sh))
  ];
}
