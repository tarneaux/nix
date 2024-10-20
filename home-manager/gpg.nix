{ pkgs, ... }: {
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry.gtk2;
    # For SSH forwarding, see https://mlohr.com/gpg-agent-forwarding/
    enableExtraSocket = true;
  };
}
