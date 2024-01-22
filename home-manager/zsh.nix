{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  zcript = name: script: pkgs.writeScriptBin name ("#!${pkgs.zsh}/bin/zsh\n\n" + script);
in {
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
      man = "man -P 'less -RF --jump-target=.5'";
      bat = "bat --pager 'less -RF --jump-target=.5'";
    };

    zsh-abbr = {
      enable = true;
      abbreviations = {
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
        nr = "sudo nixos-rebuild switch --flake ~nix"; # Nix Rebuild
        hr = "home-manager switch --flake ~nix"; # Home-manager Rebuild
        ns = "nix-shell --command 'SHELL=zsh zsh' -p";
        nsn = "nix-shell --command 'SHELL=zsh zsh' -p nodejs";
        nsp = "nix-shell --command 'SHELL=zsh zsh' -p python3";
      };
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
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "zdharma-continuum/fast-syntax-highlighting";}
      ];
    };
    dirHashes = {
      # These hashes will be used to shorten the paths, both for commands you
      # type and in the prompt, e.g. typing cd ~g will go to ~/git.
      # XXX: trailing slashes will prevent the prompt from showing the hashed
      # directory name.
      g = "$HOME/git";
      nix = "$HOME/git/nix";
    };
    initExtra = ''
      zstyle ":completion:*" menu select

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

      PATH=$PATH:$HOME/.config/scripts # Temporary until I move scripts to nix
    '';
  };
  home.packages = [
    (zcript "__zprompt_git_info" (builtins.readFile ./config/git-segment.zsh))
    pkgs.trash-cli
  ];
}
