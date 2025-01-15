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
        extraConfig = ''
          # Fix issue where skipping while playing makes MPD hang
          audio_output {
            type "pulse"
            name "Local PulseAudio Server"
          }
        '';
      };
    mpdris2 = {
      enable = true; # for playerctl integration
    };
  };
  programs.ncmpcpp.enable = true;
}
