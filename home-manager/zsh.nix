{ config
, pkgs
, hostname
, lib
, ...
}:
let
  privesc_wrong = # Wrong privilege escalation command
    if hostname == "framy"
    then "doas"
    else "sudo";
  privesc_right = # Right privilege escalation command
    if hostname == "framy"
    then "sudo"
    else "doas";
  docker =
    if hostname == "framy"
    then "podman"
    else "doas docker";
  zcript = name: script: pkgs.writeScriptBin name ("#!${pkgs.zsh}/bin/zsh\n\n" + script);
in
{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    shellAliases = {
      # Use eza for listing files
      ls = "${pkgs.unstable.eza}/bin/eza --icons --group-directories-first";

      # Use less as man & bat pagers
      man = "${pkgs.unstable.bat-extras.batman}/bin/batman";
    } // (if hostname == "framy" then {
      # Reload wifi kernel module, useful when wifi doesn't work after resume
      wr = "sudo modprobe -r mt7921e && sudo modprobe mt7921e";
    } else { });

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
          or = "${privesc_right} nixos-rebuild switch --flake ~nix";
          hr = "home-manager switch --flake ~nix";
          ns = "nix shell";
          nr = "nix run";
          nd = "nix develop -c 'zsh'";
          nsn = "nix shell nixpkgs#nodejs";
          nrn = "nix run nixpkgs#nodejs";
          nsp = "nix shell nixpkgs#python3";
          nrp = "nix run nixpkgs#python3";

          # Misc
          passgen = "tr -dc A-Za-z0-9 < /dev/urandom | head -c 64; echo";
          s = "maim -su | xclip -selection clipboard -t image/png";
          lg = "lazygit";
          y = "yazi";

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
        (lib.mkIf (hostname == "framy") {
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
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zdharma-continuum/fast-syntax-highlighting"; }
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
    };
    initExtra = ''
      zstyle ":completion:*" menu select

      _comp_options+=(globdots) # Include hidden files in filename completion

      # Re-set cursor after each command
      __reset-cursor() {printf '\033[5 q'}
      add-zsh-hook precmd "__reset-cursor"

      # And reload the tmux bar, so that segments are updated faster
      __reload-tmux-bar() {tmux refresh-client -S > /dev/null 2>&1}
      add-zsh-hook precmd "__reload-tmux-bar"

      # Enable substitution in the prompt.
      setopt prompt_subst

      PROMPT=""
      PROMPT+='%F{yellow}%n@%m ' # Display the username followed by @ and hostname in yellow
      PROMPT+='%F{blue}%~' # Display the current working directory in blue
      PROMPT+='%F{red}$(__zprompt_git_info)%f ' # Display the vcs info in red
      PROMPT+='%(?.%F{green}λ .%F{red}λ )' # Display a green prompt if the last command succeeded, or red if it failed
      PROMPT+='%f' # Reset the text color

      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };
  home.packages =
    [
      (zcript "__zprompt_git_info" (builtins.readFile ./config/git-segment.zsh))
      (zcript "ntmux" (builtins.readFile ./config/ntmux.zsh))
      pkgs.trash-cli
      pkgs.nix-index
      pkgs.tldr
      pkgs.yazi
    ]
    ++ lib.lists.optionals (hostname == "framy") [
      # Exit all SSH control sockets.
      (zcript "sc" ''
        ls ~/.ssh/ \
          | sed -n "s/\\(S\..*:[0-9]*\\)/\.ssh\/\\1/p" \
          | grep -v "^.ssh/S.tarneo@ssh.renn.es" \
          | tee /dev/fd/2 \
          | xargs -r -I {} ssh -o ControlPath={} -O exit ThisArgDoesNotMatter
      '')
    ];
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
}
