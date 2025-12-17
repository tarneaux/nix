let
  issou = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGg91bCgrnL9J8WZ2L2M9XlCWxYnyQoV0HdWKlKMd5xI root@issou";
  chankla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFW5bmlmai0nqBqndnsqY3HoBsqxKxEaqRvt9L+xhFgg root@chankla";
in
{
  "restic/issou/env.age".publicKeys = [ issou ];
  "restic/issou/password.age".publicKeys = [ issou ];
  "restic/issou/repo.age".publicKeys = [ issou ];
  "restic/chankla/env.age".publicKeys = [ chankla ];
  "restic/chankla/password.age".publicKeys = [ chankla ];
  "restic/chankla/repo.age".publicKeys = [ chankla ];
}
