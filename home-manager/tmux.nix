{username, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile ./config/tmux.conf;
    prefix = (if username == "tarneo" then "C-a" else "C-b");
  };
}
