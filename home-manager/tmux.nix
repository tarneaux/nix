{username, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile ./config/tmux.conf
      + (
        if username == "tarneo"
        then ''
          # remap prefix from 'C-b' to 'C-a'
          unbind C-b
          set-option -g prefix C-a
          bind-key C-a send-prefix
        ''
        else ""
      );
  };
}
