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
            inotifywait -e modify .
        done
      '';
    })
    (pkgs.writeShellApplication {
      # Create a new journal entry.
      name = "nje";
      text = "nvim +:NewJournalEntry";
    })
  ];
}
