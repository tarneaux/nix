{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
    {
      plugin = gruvbox;
      config = "colorscheme gruvbox";
    }
    {
      plugin = lualine-nvim;
      config = "lua require('lualine').setup{}";
    }
  ];
}
