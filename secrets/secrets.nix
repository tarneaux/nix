let
  chankla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmSbq63+rfwuwqnwKot6tTk3qd9cf1LO8TUwArADwDV root@chankla";
in
{
  "restic/chankla/env.age".publicKeys = [ chankla ];
  "restic/chankla/password.age".publicKeys = [ chankla ];
  "restic/chankla/repo.age".publicKeys = [ chankla ];
}
