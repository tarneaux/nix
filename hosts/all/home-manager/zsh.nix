{ pkgs, ... }:

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
}
