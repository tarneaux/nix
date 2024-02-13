{ ... }: {
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "yo" = "yank inline [[{url}][{title}]]"; # Copy link in org-mode format
        ",i" = "open https://iv.renn.es/watch?{url:query}"; # Youtube -> Invidious
        # arrows -> HJKL actions because I use a non-qwerty keyboard (colemak)
        "<Shift+Left>" = "back";
        "<Shift+Right>" = "forward";
        "<Shift+Up>" = "tab-prev";
        "<Shift+Down>" = "tab-next";
      };
    };
    searchEngines = {
      "DEFAULT" = "https://searx.renn.es/search?q={}";
      "aw" = "https://wiki.archlinux.org/?search={}";
      "no" = "https://search.nixos.org/options?channel=unstable&query={}";
      "np" = "https://nixos.org/nixos/packages.html?channel=unstable&query={}";
      "yt" = "https://iv.renn.es/results?search_query={}";
      "w" = "https://en.wikipedia.org/wiki/Special:Search?search={}";
      "wf" = "https://fr.wikipedia.org/wiki/Special:Search?search={}";
    };
    settings = {
      colors.webpage.preferred_color_scheme = "dark";
      auto_save.session = true;
      url.default_page = "https://searx.renn.es";
      url.start_pages = "https://searx.renn.es";
      hints.chars = "arstneoi"; # Use colemak-friendly hints (home row)
      content.pdfjs = true;
    };
    extraConfig = ''
      ${builtins.readFile ./config/qutebrowser-gruvbox.py}

      import subprocess
      res = subprocess.check_output(['sh', '-c', 'xrandr | grep primary | grep -oE "[0-9]+x[0-9]+"']).strip()
      if res == b'2560x1080':
          c.zoom.default = '70%'
          c.fonts.default_size = '8pt'
      else:
          c.zoom.default = '120%'
          c.fonts.default_size = '14pt'
    '';
  };
  home.packages = [
    #pkgs.pdfjs
  ];
}
