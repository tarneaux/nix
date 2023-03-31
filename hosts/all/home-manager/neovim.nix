{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
    # Gruvbox colorscheme
    {
      plugin = gruvbox;
      config = "colorscheme gruvbox";
    }
    # Lualine = statusline
    {
      plugin = lualine-nvim;
      config = "lua require('lualine').setup{}";
    }
    # NvimTree = file explorer
    {
      plugin = nvim-tree-lua;
      config = "lua require('nvim-tree').setup{}";
    }
    # UndoTree = undo history and easy navigation
    {
      plugin = undotree;
    }
  ];
}
