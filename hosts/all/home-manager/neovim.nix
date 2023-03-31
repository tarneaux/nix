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
      config = "require('nvim-tree').setup{}";
      type = "lua";
    }
    # UndoTree = undo history and easy navigation
    {
      plugin = undotree;
    }
    # Treesitter = syntax highlighting
    {
      plugin = nvim-treesitter;
      config = "require('nvim-treesitter.configs').setup{
        languages = {'nix', 'lua', 'python'},
        modules = {
          highlight = {
            enable = true,
          },
          indent = {
            enable = true,
          },
        }
      }";
      type = "lua";
    }
    # Auto mkdir = automatically create directories when saving a file
    {
      plugin = vim-automkdir;
    }
  ];
}
