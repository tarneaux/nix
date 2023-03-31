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
      config = "require('lualine').setup{
        options = {
          component_separators = {left='', right=''},
          section_separators = {left='', right=''},
        }
      }";
      type = "lua";
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
    # Treesitter = syntax highlighting
    {
      plugin = nvim-treesitter.withPlugins(p: with p; [ lua python nix ]);
      config = "lua require('nvim-treesitter.configs').setup{languages = {'nix', 'lua', 'python'}}";
    }
    # Auto mkdir = automatically create directories when saving a file
    {
      plugin = vim-automkdir;
    }
  ];
}
