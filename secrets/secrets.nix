let
  chankla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnDleigA3arOdYGkTegPI22V+weg++/UaneiIHsIFPq root@chankla";
  issou = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGg91bCgrnL9J8WZ2L2M9XlCWxYnyQoV0HdWKlKMd5xI root@issou";
in
{
  "restic/chankla/env.age".publicKeys = [ chankla ];
  "restic/chankla/password.age".publicKeys = [ chankla ];
  "restic/chankla/repo.age".publicKeys = [ chankla ];
  "restic/issou/env.age".publicKeys = [ issou ];
  "restic/issou/password.age".publicKeys = [ issou ];
  "restic/issou/repo.age".publicKeys = [ issou ];
}
