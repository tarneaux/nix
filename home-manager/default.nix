{ is_server, ... }: {
  imports = [ ./common.nix ] ++ (if !is_server then [ ./tarneo.nix ] else [ ./risitas.nix ]);
}
