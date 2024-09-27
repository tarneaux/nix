{ hostname, config, lib, ... }:
{
  options = {
    # Option intentionally have no default value set so that they have to be set
    # correctly when adding a new server.
    custom.restic.enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Whether or not to enable backups to Backblaze B2 using Restic.
      '';
    };
    custom.restic.paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Directories to back up with restic.
      '';
    };
    custom.restic.exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        Directories to exclude from restic backups. Syntax can be found in
        restic's documentation, but you most likely want to use the absolute
        path of the directory you want to exclude.
      '';
    };
  };

  config = {
    age.secrets = lib.mkIf config.custom.restic.enable {
      "restic/${hostname}/env".file = ../../secrets/restic/${hostname}/env.age;
      "restic/${hostname}/repo".file = ../../secrets/restic/${hostname}/repo.age;
      "restic/${hostname}/password".file = ../../secrets/restic/${hostname}/password.age;
    };

    services.restic.backups = lib.mkIf config.custom.restic.enable {
      daily = {
        initialize = true;
        environmentFile = config.age.secrets."restic/${hostname}/env".path;
        repositoryFile = config.age.secrets."restic/${hostname}/repo".path;
        passwordFile = config.age.secrets."restic/${hostname}/password".path;

        paths = config.custom.restic.paths;
        exclude = config.custom.restic.exclude;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
        ];
      };
    };
  };
}
