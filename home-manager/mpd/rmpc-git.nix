{ pkgs }:
with pkgs.unstable;
rustPlatform.buildRustPackage rec {
  pname = "rmpc";
  version = "git-${src.rev}";

  src = fetchFromGitHub {
    owner = "mierak";
    repo = "rmpc";
    rev = "448142ba2d830af874845a05c3baaac945beac22";
    hash = "sha256-oY2J79/ARk1DcYcRCrdF8SxGWujXTtuNSHaMHvH9JWE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-s6BTqgmM4TGNwRTzdycqAU/76OSizcfG53aRPGLeE/Q=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    cmake
  ];

  env.VERGEN_GIT_DESCRIBE = version;

  postInstall = ''
    installManPage target/man/rmpc.1

    installShellCompletion --cmd rmpc \
    --bash target/completions/rmpc.bash \
    --fish target/completions/rmpc.fish \
    --zsh target/completions/_rmpc
  '';
}
