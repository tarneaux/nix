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
      fzf_output=$(echo "$windows" \
        | fzf --prompt="Switch to window: " --reverse --print-query)
      fzf_exit_code=$?

      if [ $fzf_exit_code -eq 130 ]; then
        # The user escaped the fzf window
        exit 0
      fi

      if [ $fzf_exit_code -eq 0 ]; then
        # The user selected a window

        # Get the second line of the output (the window name)
        fzf_output=$(echo "$fzf_output" | sed -n 2p)

        # Get the window name from the output (in the parentheses)
        window=$(echo "$fzf_output" | grep -oP '(?<=\().*(?=\))')

        tmux switch-client -t "$window"
      fi

      if [ $fzf_exit_code -eq 1 ]; then
        # The user entered a window name that doesn't exist.
        # We can interpret it as the project directory name.
        directory=$(zoxide query "$fzf_output")
        if [ -n "$directory" ]; then
          # Open a new session in the directory, with the directory name as the
          # session name
          dirname=$(basename "$directory")
          tmux new-session -c "$directory" -s "$dirname" -d

          # Find the session id of the new session
          session_id=$(tmux list-sessions -F '#S:#{session_path}' \
            | grep "$directory" \
            | cut -d: -f1)
          tmux switch-client -t "$session_id"
        fi
      fi
    '')
  ];
}
