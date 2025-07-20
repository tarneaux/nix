# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  unisond = import ./unisond pkgs;
  rmpc-git = import ./rmpc-git.nix pkgs;
}
