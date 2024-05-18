# nix

These are my NixOS and Home-manager configurations for my (Framework) laptop and a config draft for one of my [servers](https://renn.es). They are based on the very good [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) template.

There are two configured hosts:
- `framy`: My daily driver Framework laptop.
- `issou` and `chankla`: Two thinkcentre 1L servers.
- `gaspacho`: A dell Optiplex used for backups.
- `chorizo`: An OVH VPS used as a VPN host and network gateway.

There are two configured users in home-manager:
- `tarneo`: Me, on my laptop.
- `risitas`: An administrator user on the servers.

Previous versions of my dotfiles are available on my [.f](https://github.com/tarneaux/.f) repo.

Roadmap:
- [ ] TMPFS for [root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) and [home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/) for true immutability
