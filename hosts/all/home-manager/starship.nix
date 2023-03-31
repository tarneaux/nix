{ pkgs, lib, ... }:

{
  enable = true;
  enableZshIntegration = true;
  settings = {
    add_newline = false;
    format = lib.concatStrings [
      "$username"
      "$hosname"
      "$shlvl"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_status"
      "$nodejs"
      "$ruby"
      "$cmd_duration"
      "$line_break"
      "$jobs"
      "$status"
      "$character"
    ];
    character = {
      success_symbol = "[λ](bold green)";
      error_symbol = "[λ](bold red)";
    };
    line_break = {
      disabled = true;
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
      format = "[⏱ $duration](bold yellow) ";
    };
  };
}
