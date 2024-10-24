{ config, ... }:
{
  services = {
    mpd =
      let
        musicDirectory = "${config.home.homeDirectory}/Music";
      in
      {
        enable = true;
        musicDirectory = musicDirectory;
        playlistDirectory = "${musicDirectory}/playlists";
      };
    mpdris2 = {
      enable = true; # for playerctl integration
    };
  };
  programs.ncmpcpp.enable = true;
}
