{username, ...}: {
  programs.git = {
    enable = true;
    userName = "tarneo";
    userEmail = "tarneo@tarneo.fr";
    signing = {
      key = null; # Let GPG decide
      signByDefault = username == "tarneo";
    };
    extraConfig = {
      credential.helper = "store";
      init.defaultBranch = "main";
    };
  };
}
