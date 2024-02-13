{ pkgs, ... }: {
  home.packages = [
    pkgs.nsxiv
  ];
  home.file.".config/nsxiv/exec/key-handler" = {
    text = ''
      #!${pkgs.bash}/bin/bash
      while read file; do
        case "$1" in
          "y")
            # Copy the absolute path to the clipboard.
            # Will select the last one if multiple are selected.
            # This has the side-effect of adding a dot in the middle of the
            # path, but it's not a big deal since it evaluates to the same path.
            echo -n "$PWD/$file" | ${pkgs.xclip}/bin/xclip -selection clipboard ;;
          "Y")
            # Copy the image ITSELF to the clipboard.
            # Will select the last one if multiple are selected.
            ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i "$file" ;;
          "p")
            echo "$line" ;;
          "r")
            ${pkgs.imagemagick}/bin/convert -rotate 90 "$file" "$file" ;;
          "R")
            ${pkgs.imagemagick}/bin/convert -rotate -90 "$file" "$file" ;;
          esac
      done
    '';
    executable = true;
  };
}
