{ pkgs }:
with pkgs.unstable;
rustPlatform.buildRustPackage rec {
  pname = "rmpc";
  version = "git-${src.rev}";

  src = fetchFromGitHub {
    owner = "mierak";
    repo = "rmpc";
    rev = "f0c0a1e67ce19728e365a47dcc8bf2251b797f93";
    hash = "sha256-OwGdRyE9uQZKM/0ZsieYA5hO2W0lmiAzlvOkmUR56qk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZHajqTkdw0wkNVws0fr9HFcC3JF1B6TuwP5CTGw/3nQ=";

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
