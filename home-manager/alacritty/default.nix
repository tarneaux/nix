{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "0x928374";
          blue = "0x83a598";
          cyan = "0x8ec07c";
          green = "0xb8bb26";
          magenta = "0xd3869b";
          red = "0xfb4934";
          white = "0xebdbb2";
          yellow = "0xfabd2f";
        };
        normal = {
          black = "0x282828";
          blue = "0x458588";
          cyan = "0x689d6a";
          green = "0x98971a";
          magenta = "0xb16286";
          red = "0xcc241d";
          white = "0xa89984";
          yellow = "0xd79921";
        };
        primary = {
          background = "0x282828";
          foreground = "0xebdbb2";
        };
      };
      cursor = {
        blink_interval = 500;
        blink_timeout = 10;
        thickness = 0.25;
        unfocused_hollow = false;
        style = {
          blinking = "On";
          shape = "Beam";
        };
        vi_mode_style = {
          shape = "Beam";
        };
      };
      env = {
        TERM = "xterm-256color";
      };
      font = {
        size = 7;
        normal = {
          family = "FantasqueSansM Nerd Font";
          style = "Regular";
        };
      };
      keyboard = {
        bindings = [
          {
            chars = "\e[13;2u";
            key = "Return";
            mods = "Shift";
          }
          {
            chars = "\e[13;5u";
            key = "Return";
            mods = "Control";
          }
        ];
      };
      mouse = {
        hide_when_typing = true;
      };
      scrolling = {
        history = 100000;
      };
      window = {
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
