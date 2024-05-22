{ hostname, config, ... }:
{
  age.secrets = {
    "restic/${hostname}/env".file = ../../secrets/restic/${hostname}/env.age;
    "restic/${hostname}/repo".file = ../../secrets/restic/${hostname}/repo.age;
    "restic/${hostname}/password".file = ../../secrets/restic/${hostname}/password.age;
  };

  services.restic.backups = {
    daily = {
      initialize = true;
      environmentFile = config.age.secrets."restic/${hostname}/env".path;
      repositoryFile = config.age.secrets."restic/${hostname}/repo".path;
      passwordFile = config.age.secrets."restic/${hostname}/password".path;

      paths = [
        "/data"
        "/hdd/data"
        "/home/risitas/services/"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}
