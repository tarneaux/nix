{ ... }: {
  programs.mpv = {
    enable = true;
    config = {
      # volume = 35;
      no-keepaspect-window = "";
    };
  };
}
