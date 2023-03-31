{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  plugins = with pkgs.vimPlugins; [
    { plugin = gruvbox;
      config = "colorscheme gruvbox";
    }
  ];
}
