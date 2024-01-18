{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
      # Create default dynamic.py if it doesn't exist
      import os
      file_path = "${config.xdg.configHome}/qutebrowser/dynamic.py"
      if not os.path.exists(file_path):
        import shutil
        shutil.copyfile(
          file_path + ".example",
          file_path
        )
      # Read font size & zoom from ~/.config/qutebrowser/dynamic.py
      config.source('dynamic.py')
      ${builtins.readFile ./config/qutebrowser-gruvbox.py}
    '';
  };
  home.file.".config/qutebrowser/dynamic.py.example".source = ./config/qutebrowser-dynamic.py.example;
  home.packages = [
    #pkgs.pdfjs
  ];
}
