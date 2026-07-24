{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rofi-rbw
    xdotool
  ];

  programs.rbw = {
    enable = true;
    settings = {
      email = "tarneo@tarneo.fr";
      lock_timeout = 300;
      pinentry = pkgs.pinentry-qt;
    };
  };

  home.file.".config/rofi-rbw.rc".text = ''
    keybindings=Alt+x:copy:username
    target=password
  '';
}
