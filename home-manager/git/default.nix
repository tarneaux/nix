{ is_server, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "tarneo";
    userEmail = "tarneo@tarneo.fr";
    signing = {
      key = null; # Overriden in includes below
      signByDefault = true;
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
    includes =
      (lib.lists.optionals (!is_server) [
        {
          contents.user = {
            email = "tarneo@tarneo.fr";
            signingKey = "4E7072A78326617F";
          };
        }
      ])
      ++ [
        {
          condition = if is_server then null else "gitdir:~/renn.es/";
          contents.user = {
            email = "admin@renn.es";
            signingKey = "6F145B0C9A5BFC47";
          };
        }
      ];
  };
  home.file.".config/git/ignore".text = ''
    .envrc
    .direnv
    todo.org
  '';
}
