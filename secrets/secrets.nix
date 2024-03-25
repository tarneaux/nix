let
  plancha-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDuMnNWKbnNFIGzuPcXz2NPv8FdOavPJNY+/hQm/XEa2 root@plancha";
  plancha-risitas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPK30XZub/6TWgfia+ekjDsiWZNviatUf4Pa9yrsBJlM risitas@plancha";

  issou-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGg91bCgrnL9J8WZ2L2M9XlCWxYnyQoV0HdWKlKMd5xI root@issou";
  issou-risitas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgtQVt7ZzpEju0+oIPzMphzHhbhUyvbzsklcTTi7KQo risitas@issou";

  gaspacho-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrH5lIONOCZX0nOH0Kva5NUv/Nd7wc/m6cQiyWDC1tk root@gaspacho";
in
{
  "k3s.age".publicKeys = [ plancha-system plancha-risitas issou-system issou-risitas gaspacho-system ];
}
