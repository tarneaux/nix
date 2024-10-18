{ is_server, ... }:
let
  username =
    if is_server
    then "risitas"
    else "tarneo";
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
}
