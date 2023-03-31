{ pkgs, lib, ... }:

{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  dotDir = ".config/zsh";
  history = {
    extended = true;
    ignoreDups = true;
    share = true;
  };

  initExtra = lib.strings.concatStringsSep "\n" [
    # General aliases
    "alias t='trash'"
    "alias v='nvim'"
    "alias g='git'"

    # Confirm irrevocable commands
    "alias cp='cp -i'"
    "alias mv='mv -i'"
    "alias rm='rm -i'"

    # Shadowed system commands
    "alias ls='exa --color=auto --icons --group-directories-first'"
    "alias ll='ls -l'"
    "alias la='ls -la'"
    "alias tree='ls --tree'"

    # Git aliases
    "alias ga='git add'"
    "alias gap='git add --patch'"
    "alias gc='git commit'"
    "alias gca='git commit --amend'"
    "alias gcm='git commit --message'"
    "alias gcam='git commit --amend --message'"
    "alias gp='git push'"
    "alias gs='git status'"
    "alias gd='git diff'"
    "alias gb='git branch'"
    "alias gco='git checkout'"
    "alias gl='git log --decorate --oneline --graph'"
  ];
}
