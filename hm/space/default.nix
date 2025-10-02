# Configs for my markdown space, synced with my silverbullet instance.

{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      # Daemon for automatically committing changes in the space.
      name = "space-autocommit";
      text = ''
        cd ~/space/ || exit 1

        while true; do
            if [ "$(git status --porcelain | wc -l)" -ne 0 ]; then
                echo "Committing."
                git add .
                git commit -m "Auto commit"
            fi
            inotifywait -r -e modify .
        done
      '';
    })
    (pkgs.writeShellApplication {
      name = "journal-build";
      text = builtins.readFile ./journal-build.sh;
    })
  ];
  programs.zk = {
    enable = true;
    settings = {
      notebook.dir = "~/space";
      note = {
        filename = "{{slug title}}";
        extension = "md";
      };
      group.journal = {
        paths = [ "journal" ];
        note.filename = "journal/{{format-date now '%Y-%m-%d %a'}}/{{format-date now '%H-%M-%S'}}";
      };
    };
  };
}
