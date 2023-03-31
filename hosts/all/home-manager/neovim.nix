{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  extraLuaConfig = "
  vim.opt.rnu = true -- Show line numbers
  vim.opt.signcolumn = 'number' -- Show line numbers in the sign column
  vim.opt.shiftwidth = 4 -- Indentation width
  vim.opt.expandtab = true -- Use spaces instead of tabs
  vim.opt.smarttab = true -- Use smart tabbing
  vim.opt.linebreak = true -- Wrap long lines
  vim.opt.swapfile = false -- Disable those annoying swap files
  vim.opt.clipboard = 'unnamedplus' -- Copy to system clipboard
  vim.opt.undofile = true -- Enable undo history
  vim.opt.undodir = vim.fn.expand('~/.local/share/nvim-undodir') -- Set undo history directory
  vim.opt.scrolloff = 1 -- Keep 1 line above and below the cursor
  vim.opt.autoread = true -- Reload file if it changes on disk
  vim.cmd.highlight('SignColumn', 'guibg=NONE') -- Disable background color for sign column
  vim.opt.termguicolors = true -- Enable 24-bit colors
  ";
  extraConfig = "autocmd VimLeave * set guicursor=a:ver25-blinkon0"; # Prevent block cursor from staying after quitting
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
    # LSP = language server protocol. Used for autocompletion, go to definition, etc.
    {
      plugin = nvim-lspconfig;
      config = "
        require('lspconfig').pyright.setup{}
        require('lspconfig').bashls.setup{}
        require('lspconfig').rnix.setup{}
      ";
      type = "lua";
    }
    # Autopairs = automatically close brackets, quotes, etc.
    {
      plugin = nvim-autopairs;
      config = "require('nvim-autopairs').setup{}";
      type = "lua";
    }
    # Copilot = absolutely proprietary, but very useful AI-assisted code completion
    copilot-vim
    # Guess indent = automatically guess the indentation width of a file (duh)
    {
      plugin = guess-indent-nvim;
      config = "require('guess-indent').setup{}";
      type = "lua";
    }
    # Trouble = show LSP diagnostics in a floating window
    {
      plugin = trouble-nvim;
      config = "require('trouble').setup{}";
      type = "lua";
    }
    # GitGutter = show git diff in the gutter
    {
      plugin = vim-gitgutter;
      config = "
        hi GitGutterAdd guibg=NONE
        hi GitGutterChange guibg=NONE
        hi GitGutterDelete guibg=NONE
      ";
      type = "viml";
    }
  ];
  extraPackages = with pkgs; [
    pyright nodePackages.bash-language-server rnix-lsp # LSP servers
    nodejs # Needed for copilot
  ];
}
