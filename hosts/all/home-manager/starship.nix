{ pkgs, lib, ... }:

{
  enable = true;
  enableZshIntegration = true;
  settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$username"
      "$hosname"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_status"
      "$cmd_duration"
      "$jobs"
      "$character"
    ];
    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold red)";
    };
    git_status = {
      conflicted = "!";
      ahead = "↑";
      behind = "↓";
      diverged = "↕";
      untracked = "?";
      stashed = ""; # Here we use the nerd font icon to prevent an error
      modified = "!";
      staged = "+";
      renamed = "»";
      deleted = "✘";
    };
    git_branch = {
      symbol = "שׂ ";
    };
    cmd_duration = {
      format = "[$duration](bold yellow) ";
    };
  };
}
