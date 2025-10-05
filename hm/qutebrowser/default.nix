{ pkgs, lib, ... }:
{
  programs.qutebrowser = {
    enable = true;
    keyBindings = {
      normal = {
        "yo" = "yank inline [[{url}][{title}]]"; # Copy link in org-mode format
        ",d" = "cmd-set-text -s :spawn dump \"[{title}]({url})\": "; # Bookmark to wiki
        ",m" = ''spawn sh -c "yt-dlp {url} -o - | mpv - -force-seekable=yes"'';
        ",M" = ''hint links spawn sh -c "yt-dlp {url} -o - | mpv - -force-seekable=yes"'';
        # arrows -> HJKL actions because I use a non-qwerty keyboard (colemak)
        "<Shift+Left>" = "back";
        "<Shift+Right>" = "forward";
        "<Shift+Up>" = "tab-prev";
        "<Shift+Down>" = "tab-next";
        "<Shift+h>" = "back";
        "<Shift+l>" = "forward";
        "<Shift+j>" = "tab-prev";
        "<Shift+k>" = "tab-next";
        "tn" = "back -t";
        "to" = "forward -t";
        "a" = "tab-focus last";
        "tt" = "config-cycle tabs.show multiple never";
        "tj" = "config-cycle -p -u *://{url:host}/* content.javascript.enabled ;; reload";
        "tJ" = "config-cycle -p -t -u *://{url:host}/* content.javascript.enabled ;; reload";
      };
    };
    searchEngines = {
      "DEFAULT" = "https://searx.renn.es/search?q={}";
      "!aw" = "https://wiki.archlinux.org/?search={}";
      "!no" = "https://search.nixos.org/options?channel=unstable&query={}";
      "!np" = "https://nixos.org/nixos/packages.html?channel=unstable&query={}";
      "!yt" = "https://iv.renn.es/results?search_query={}";
      "!w" = "https://en.wikipedia.org/wiki/Special:Search?search={}";
      "!wf" = "https://fr.wikipedia.org/wiki/Special:Search?search={}";
      "!rs" = "https://docs.rs/std/?search={}";
      "!rc" = "https://docs.rs/{0}/latest/{0}";
    };
    settings = {
      colors.webpage.preferred_color_scheme = "dark";
      auto_save.session = true;
      url.default_page = "https://searx.renn.es";
      url.start_pages = "https://searx.renn.es";
      hints.chars = "arstneoi"; # Use colemak-friendly hints (home row)
      tabs.position = "left";
      tabs.show = "multiple";
      content.autoplay = false;
      downloads.location.directory = "~/Downloads/";
      content.javascript.enabled = false;
    };
    extraConfig = ''
      ${builtins.readFile ./qutebrowser-gruvbox.py}

      import subprocess
      res = subprocess.check_output(
        ['sh', '-c', 'xrandr | grep primary | grep -oE "[0-9]+x[0-9]+"']
      ).strip()
      if res == b'2560x1080':
          c.zoom.default = '70%'
          c.fonts.default_size = '8pt'
      else:
          c.zoom.default = '120%'
          c.fonts.default_size = '15pt'

      import os

      # Add profile name to statusbar
      profile = os.path.basename(os.path.dirname(os.path.dirname(__file__)))
      c.statusbar.widgets = [
          "keypress", "search_match", "url", "scroll", "history", "tabs", "progress",
          f"text:<{profile}>"
      ]
    '';
    greasemonkey = [
      (pkgs.writeText "youtube-ads.js" ''
        // ==UserScript==
        // @name Skip YouTube ads
        // @description Skips the ads in YouTube videos
        // @run-at document-start
        // @include *.youtube.com/*
        // ==/UserScript==

        document.addEventListener('load', () => {
            const btn = document.querySelector('.videoAdUiSkipButton,.ytp-ad-skip-button-modern')
            if (btn) {
                btn.click()
            }
            const ad = [...document.querySelectorAll('.ad-showing')][0];
            if (ad) {
                document.querySelector('video').currentTime = 9999999999;
            }
        }, true);
      '')
    ];
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "dump";
      text = ''
        {
          echo "$*"
          printf "\n"
        } >> ~/space/linkdump.md
      '';
    })
    (pkgs.writeShellApplication {
      name = "qprofile";
      text = lib.readFile ./qprofile.sh;
    })
    (pkgs.writeShellApplication {
      name = "qprofile-menu";
      text = ''
        cat \
        <(find ~/.config/qb-profiles/ -mindepth 1 -maxdepth 1 -type d -printf '%P\n') \
        <(echo tmp) \
        | rofi -dmenu -p profile \
        | xargs -r -I '{}' qprofile '{}' "$@"
      '';
    })
  ];
  xdg.desktopEntries = {
    qprofile = {
      name = "Qutebrowser Profile";
      genericName = "Web Browser";
      exec = "qprofile-menu %U";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/qute"
        "x-scheme-handler/about"
      ];
    };
  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "qprofile.desktop" ];
    "x-scheme-handler/http" = [ "qprofile.desktop" ];
    "x-scheme-handler/https" = [ "qprofile.desktop" ];
    "x-scheme-handler/about" = [ "qprofile.desktop" ];
    "x-scheme-handler/qute" = [ "qprofile.desktop" ];
  };
}
