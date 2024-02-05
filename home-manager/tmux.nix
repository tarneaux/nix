{
  username,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile ./config/tmux.conf;
    prefix =
      if username == "tarneo"
      then "C-a"
      else "C-b";
  };
  home.packages = [
    (pkgs.writeScriptBin "__tmux_fzf_window" ''
      #!${pkgs.bash}/bin/bash
      ${
        # Make sure ssh sessions are available
        if username == "tarneo"
        then "sshtmux"
        else ""
      }
      windows=$(tmux list-windows -aF '#W (#S:#I)')
      window=$(echo "$windows" | fzf --prompt="Switch to window: " --reverse)
      # Get the window name from the output (in the parentheses)
      window=$(echo "$window" | grep -oP '(?<=\().*(?=\))')
      if [ -n "$window" ]; then
        tmux switch-client -t "$window"
      fi
    '')
  ];
}
