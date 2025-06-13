{
  config,
  pkgs,
  is_server,
  lib,
  hostname,
  ...
}:
let
  privesc_wrong = "sudo";
  privesc_right = "doas";
  nix_job_limit_arg = if (hostname == "chorizo") then " -j 1" else "";
  docker = if is_server then "doas docker" else "podman";
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreAllDups = true;
    };

    historySubstringSearch = {
      enable = true;
      searchUpKey = "^[OA";
      searchDownKey = "^[OB";
    };

    autosuggestion.enable = true;
    localVariables.ZSH_AUTOSUGGEST_STRATEGY = [
      "history"
      "completion"
    ];

    shellAliases =
      {
        # Use eza for listing files
        ls = "${pkgs.eza}/bin/eza --icons --group-directories-first";

        # Use less as man & bat pagers
        man = "${pkgs.bat-extras.batman}/bin/batman";
      }
      // lib.attrsets.optionalAttrs (!is_server) {
        # Reload wifi kernel module, useful when wifi doesn't work after resume
        wr = "sudo modprobe -r mt7921e && sudo modprobe mt7921e";
      };

    zsh-abbr = {
      enable = true;
      abbreviations = lib.mkMerge [
        {
          # Ls
          l = "ls";
          ll = "ls -l";
          la = "ls -a";
          lla = "ls -la";
          lt = "ls --tree";
          tree = "ls --tree";

          # Trash
          t = "trash";
          tr = "trash-restore";

          # File operations
          rm = "rm -i";
          cp = "cp -i";
          mv = "mv -i";

          # Git
          g = "git";
          gs = "git status";
          ga = "git add";
          gap = "git add -p";
          gc = "git commit";
          gp = "git push";
          gpu = "git push -u origin main";
          gl = "git log --decorate --oneline --graph";
          gd = "git diff";
          gr = "git restore";
          grs = "git restore --staged";
          gco = "git checkout";
          gb = "git branch";

          # Tmux
          tm = "tmux";
          tma = "tmux attach -t";
          tml = "tmux ls";
          tmk = "tmux kill-session -t";
          tmn = "tmux new-session -s";

          # Nixos
          or = "${privesc_right} nixos-rebuild switch --flake ~nix" + nix_job_limit_arg;
          hr = "home-manager switch --flake ~nix" + nix_job_limit_arg;
          ns = "nix shell";
          nr = "nix run";
          nd = "nix develop -c 'zsh'";
          nsn = "nix shell nixpkgs#nodejs";
          nrn = "nix run nixpkgs#nodejs";
          nsp = "nix shell nixpkgs#python3";
          nrp = "nix run nixpkgs#python3";

          # Misc
          passgen = "tr -dc A-Za-z0-9 < /dev/urandom | head -c 64; echo";
          reduce = "mkdir -p ~/reduced && mogrify -path ~/reduced -verbose -resize x1080 *.JPG";
          reducevideo = ''for file in *.MP4; do ffmpeg -i "$file" -crf 28 -af volume=7 "$HOME/reduced/$file"; done'';
          s = "maim -su | xclip -selection clipboard -t image/png";
          lg = "lazygit";
          y = "yazi";
          cmm = "zathura ~/fac/maths/cours.pdf";
          arc = "archive";
          black = "ruff";
          q = "nvim +:ZettelkastenQuickNote";

          # docker / podman
          d = docker;
          docker = docker;
          # In the following, \\\\t resolves to \\t in the abbr, which resolves to
          # \t in the shell, which resolves to a tab in the output.
          # This prevents from adding an actual tab in the prompt when using the
          # abbr.
          dp = "${docker} ps -a --format 'table {{.Names}}\\\\t{{.Status}}'";
          dcu = "${docker} compose up -d";
          dcd = "${docker} compose down";
          dcr = "${docker} compose restart";
          dcl = "${docker} compose logs -f";

          # Correct the common mistake of using sudo instead of doas
          ${privesc_wrong} = privesc_right;
        }
        (lib.mkIf (!is_server) {
          # VPN
          vu = "${privesc_right} wg-quick up vpn";
          vd = "${privesc_right} wg-quick down vpn";
        })
      ];
    };

    sessionVariables =
      let
        pager = "less -RF --jump-target=.5";
      in
      {
        BAT_PAGER = pager;
        PAGER = pager;

        ARCHIVE_DIR = "$HOME/.sync/archive";
      };

    # Without the option below, compinit takes 3+ secs to load.
    # By adding a cache with the -d option it becomes much faster
    completionInit = ''
      autoload -U compinit
      compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };

    dirHashes = {
      # These hashes will be used to shorten the paths, both for commands you
      # type and in the prompt, e.g. typing cd ~g will go to ~/git.
      # XXX: trailing slashes will prevent the prompt from showing the hashed
      # directory name.
      g = "$HOME/git";
      nix = "$HOME/git/nix";
      s = "$HOME/.sync";
      ar = "$ARCHIVE_DIR";
    };

    localVariables.PROMPT = lib.strings.concatStrings [
      "%F{yellow}%n@%m " # username@hostname
      "%F{blue}%~" # working dir, with hash substitution
      "%F{red}\\$(__zprompt_git_info)%f " # git info
      "%(?.%F{green}λ .%F{red}λ )" # green or red prompt symbol depending on exit status
      "%f" # Reset text color
    ];

    initContent = lib.strings.concatStringsSep "\n" (
      [
        ''
          zstyle ":completion:*" menu select

          # Allow executing shell scripts in prompt
          setopt prompt_subst

          # Include hidden files in filename completion
          _comp_options+=(globdots)


          # Reload the tmux bar after each command for faster updates
          __reload-tmux-bar() {tmux refresh-client -S > /dev/null 2>&1}
          add-zsh-hook precmd "__reload-tmux-bar"

          # Set window titles depending on commands and user@hostname
          function __set_title() {
            title=$(print -nP "%n@%m %~ $ $1") # $1 is the running command, if there is one
            echo -n "\033]0;$title\a"
          }
          add-zsh-hook preexec __set_title
          add-zsh-hook precmd __set_title

          # Display which package contains a command when it isn't found
          source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
        ''
      ]
      ++ (
        if is_server then
          [
            ''
              # Warn about unapplied updates
              __kernel_update_info () {
                local versions="$(readlink /run/{current,booted}-system/kernel \
                    | sed -ne 's|.*-linux-\([0-9.]*\)/bzImage|\1|p' \
                    | uniq \
                    | sort)"
                if [ $(wc -l <<< "$versions") -eq 2 ]; then
                  tr -s '\n' ' ' <<< "$versions" \
                    | awk '{print "kernel updated from " $1 " to " $2 ", a reboot may be needed"}'
                fi
              }
              __kernel_update_info
            ''
          ]
        else
          [
            ''
              # Start the SSH agent and add the authentication key for remote auth with
              # a FIDO key
              eval $(ssh-agent) > /dev/null
              ssh-add -q ~/.ssh/id_ed25519_sk_auth
            ''
          ]
      )
    );
  };
  home.packages =
    [
      (pkgs.writeShellApplication {
        name = "__zprompt_git_info";
        text = builtins.readFile ./git-segment.zsh;
      })
      (pkgs.writeShellApplication {
        name = "archive";
        text = builtins.readFile ./archive.sh;
      })
      pkgs.trash-cli
      pkgs.nix-index
      pkgs.tldr
      pkgs.yazi
    ]
    ++ lib.lists.optionals (!is_server) [
      # Exit all SSH control sockets.
      (pkgs.writeShellApplication {
        name = "sc";
        text = # bash
          ''
            find ~/.ssh/S.* \
              | grep -v "^$HOME/.ssh/S.tarneo@ssh.renn.es" \
              | tee /dev/fd/2 \
              | xargs -r -I {} ssh -o ControlPath={} -O exit ThisArgDoesNotMatter
          '';
      })
    ];
  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
