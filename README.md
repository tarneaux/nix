# nix

These are my NixOS and Home-manager configurations for my (Framework) laptop and a config draft for one of my [servers](https://renn.es). They are based on the very good [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) template.

There are two configured hosts:
- `framy`: My daily driver Framework laptop.
- `issou`: A thinkcentre 1L server.

There are two configured users in home-manager:
- `tarneo`: Me, on my laptop.
- `risitas`: An administrator user on the server.

I am currently gently moving my dotfiles from my [.f](https://github.com/tarneaux/.f) repo to the home-manager configs here.

Roadmap:
- [ ]: Fully migrate dotfiles
- [ ]: Actually put some stuff on the server
- [ ]: 2FA with TOTP for the server
- [ ]: Move all [renn.es](https://renn.es) servers over to NixOS
- [ ]: TMPFS for [root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) and [home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/) for true immutability
