{ ... }: {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set guioptions none
    '';
  };
}
