{ pkgs, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
    # For SSH forwarding, see https://mlohr.com/gpg-agent-forwarding/
    enableExtraSocket = true;
  };
}
