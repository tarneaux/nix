{ hostname, ... }: {
  programs.git = {
    enable = true;
    userName = "tarneo";
    userEmail = "tarneo@tarneo.fr";
    signing = {
      key = null; # Let GPG decide
      signByDefault = hostname == "framy";
    };
    delta = {
      enable = true;
    };
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
      pull.rebase = true; # Rebase by default when pulling
      merge.conflictstyle = "zdiff3"; # Also show the common ancestor
      merge.tool = "vimdiff";
      rebase.autostash = true; # Stash changes before rebasing
      push.default = "current"; # Push to a remote branch with the same name
      fetch.prune = true; # Prune remote branches when fetching
      commit.verbose = true; # Show the diff when committing
      diff.algorithm = "histogram"; # "Better" diff algorithm
      core.excludesfile = "~/.config/git/ignore"; # Use a global .gitignore
      branch.sort = "-committerdate"; # Sort branches by last commit date
      url = {
        "git@github.com:".pushInsteadOf = "https://github.com/";
        "git@github.com:".insteadOf = "gh:";
        "git@renn.es:".pushInsteadOf = "https://renn.es/";
        "git@renn.es:".insteadOf = "rennes:";
      };
    };
  };
  home.file.".config/git/ignore".text = ''
    .envrc
    .direnv
    todo.org
  '';
}
