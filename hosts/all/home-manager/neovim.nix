{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  extraLuaConfig = "
  -- Enable relative line numbers
  vim.opt.number = true
  vim.opt.relativenumber = true
  -- Show gutter in line numbers
  vim.opt.signcolumn = 'number'
  -- Disable those annoying swap files
  vim.opt.swapfile = false
  -- Store undo history between sessions
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'
  -- Set tab width to 4 spaces
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  -- Enable mouse support just in case I turn into a normie (magic!)
  vim.opt.mouse = 'a'
  -- Enable system clipboard support
  vim.opt.clipboard = 'unnamedplus'
  -- Word wrap
  vim.opt.wrap = true
  vim.opt.linebreak = true
  -- Bind S to replace every occurence (normal mode)
  vim.cmd [[map S :%s//g<Left><Left>]]
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
      config = "
        require('nvim-tree').setup{}
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require('which-key').register({
          ['<space>e'] = { ':NvimTreeToggle<cr>', 'Open/close NvimTree' },
        })
      ";
      type = "lua";
    }
    # UndoTree = undo history and easy navigation
    undotree
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
    vim-automkdir
    # nvim-cmp: autocompletion
    cmp-nvim-lsp
    {
      plugin = nvim-cmp;
      config = ''
        capabilities = require('cmp_nvim_lsp').default_capabilities()

        local cmp = require'cmp'
        cmp.setup {
          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    local copilot_keys = vim.fn['copilot#Accept']()
                    if copilot_keys ~= "" then
                        vim.api.nvim_feedkeys(copilot_keys, "n", true)
                    else
                        fallback()
                    end
                end
            end,
          },
          sources = {
            { name = 'nvim_lsp' },
          },
        }
      '';
      type = "lua";
    }
    # LSP = language server protocol. Used for autocompletion, go to definition, etc.
    {
      plugin = nvim-lspconfig;
      config = "
        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            update_in_insert = true,
          }
        )

        local servers = {'pyright', 'bashls', 'rnix'}
        for _, lsp in ipairs(servers) do
          require'lspconfig'[lsp].setup{}
        end
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
    {
      plugin = copilot-vim;
      config = ''vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_feedback = ""'';
      type = "lua";
    }
    vim-nix
    # Guess indent = automatically guess the indentation width of a file (duh)
    {
      plugin = guess-indent-nvim;
      config = "require('guess-indent').setup{}";
      type = "lua";
    }
    # Trouble = show LSP diagnostics in a floating window
    {
      plugin = trouble-nvim;
      config = "
      require('trouble').setup{}
      require('which-key').register({
          ['<space>t'] = { ':TroubleToggle<cr>', 'Open/close Trouble' },
      })
      ";
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
    # Vim-commentary = comment/uncomment lines with shortcut "gcc" (and others)
    vim-commentary
    # which-key = show keybindings in a floating window. Used in many other plugins for hotkey help
    which-key-nvim
    # Telescope = fuzzy finder
    {
      plugin = telescope-nvim;
      config = "
      require('which-key').register({
        ['<space>f'] = {
          name = 'Find',
          f = {'<cmd>Telescope find_files<cr>', 'Find files'},
          g = {'<cmd>Telescope live_grep<cr>', 'Find in files'},
          b = {'<cmd>Telescope buffers<cr>', 'Find buffers'},
          h = {'<cmd>Telescope help_tags<cr>', 'Find help'},
        }
      })
      ";
      type = "lua";
    }
    # Fugitive = git integration
    {
      plugin = fugitive;
      config = "
      require('which-key').register({
        ['<space>g'] = {
          name = 'git',
          c = { '<cmd>Git commit<cr>', 'Commit' },
          a = { '<cmd>Git add ' .. vim.fn.expand('%:p') .. '<cr>', 'Stage current file' },
          A = { '<cmd>Git add --patch ' .. vim.fn.expand('%:p') .. '<cr>', 'Stage current file selectively' },
          u = { '<cmd>Git restore --staged ' .. vim.fn.expand('%:p') .. '<cr>', 'Unstage current file' },
          p = { '<cmd>Git push<cr>', 'Push' },
          s = { '<cmd>Git status<cr>', 'Status' },
          d = { '<cmd>Git diff<cr>', 'Diff' },
          r = { '<cmd>Git restore '.. vim.fn.expand('%:p') ..'<cr>', 'Restore current file' },
          R = { '<cmd>Git restore --patch '.. vim.fn.expand('%:p') ..'<cr>', 'Restore current file selectively' },
        }
      })
      ";
      type = "lua";
    }
  ];
  extraPackages = with pkgs; [
    pyright nodePackages.bash-language-server rnix-lsp # LSP servers
    nodejs # Needed for copilot
  ];
}
