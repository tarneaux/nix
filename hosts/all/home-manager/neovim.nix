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
    # Vim-commentary = comment/uncomment lines with shortcut "gcc" (and others)
    {
      plugin = vim-commentary;
    }
    # Alpha-nvim = dashboard
    {
      plugin = alpha-nvim;
      config = ''
        require'alpha'.setup(require'alpha.themes.dashboard'.config)

        local alpha = require'alpha'
        local dashboard = require'alpha.themes.dashboard'
        dashboard.section.buttons.val = {
            dashboard.button( "e", " New file" , ":ene <BAR> startinsert <CR>"),
            dashboard.button( "spc f f", " Find file" , ":Telescope find_files<CR>"),
            dashboard.button( "spc f g", "󰍉 Find text" , ":Telescope live_grep<CR>"),
            dashboard.button( "q", " Quit NVIM" , ":qa<CR>"),
        }
        local handle = io.popen('fortune calvin -s')
        local fortune = handle:read("*a")
        handle:close()
        dashboard.section.header.val = fortune

        dashboard.config.opts.noautocmd = true

        vim.cmd[[autocmd User AlphaReady echo 'ready']]

        alpha.setup(dashboard.config)
      '';
      type = "lua";
    }
    # which-key = show keybindings in a floating window
    {
      plugin = which-key-nvim;
      config = ''
        require('which-key').register({
            ["<space>"] = {
                f = {
                    name = "Find",
                    f = { "<cmd>Telescope find_files<cr>", "Files" },
                    g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
                    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
                    h = { "<cmd>Telescope find_files hidden=true<cr>", "Hidden files" }
                },
                g = {
                    name = "Git",
                    c = { "<cmd>Git commit<cr>", "Commit" },
                    a = { "<cmd>Git add " .. vim.fn.expand('%:p') .. "<cr>", "Stage current file" },
                    A = { "<cmd>Git add --patch " .. vim.fn.expand('%:p') .. "<cr>", "Stage current file selectively" },
                    u = { "<cmd>Git restore --staged " .. vim.fn.expand('%:p') .. "<cr>", "Unstage current file" },
                    p = { "<cmd>Git push<cr>", "Push" },
                    s = { "<cmd>Git status<cr>", "Status" },
                    d = { "<cmd>Git diff<cr>", "Diff" },
                    r = { "<cmd>Git restore ".. vim.fn.expand('%:p') .."<cr>", "Restore current file" },
                    R = { "<cmd>Git restore --patch ".. vim.fn.expand('%:p') .."<cr>", "Restore current file selectively" },
                },
                b = {
                    name = "Buffers",
                    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
                    d = { "<cmd>bd<cr>", "Delete" },
                    c = { "<cmd>enew<cr>", "Close" },
                    p = { "<cmd>bp<cr>", "Previous" },
                    n = { "<cmd>bn<cr>", "Next" }
                },
                o = { "<cmd>NvimTreeToggle<cr>", "Open nvimtree" },
                i = { "<cmd>NvimTreeFocus<cr>", "Focus nvimtree" },
                q = { "<cmd>q<cr>", "Quit" },
                w = { "<cmd>w<cr>", "Write" },
                r = { "<cmd>Telescope repo list<cr>", "Registers" },
                t = { "<cmd>TroubleToggle<cr>", "Show errors" },
            }
        })
      '';
      type = "lua";
    }
    # Telescope = fuzzy finder
    telescope-nvim
    # Fugitive = git integration
    fugitive
  ];
  extraPackages = with pkgs; [
    pyright nodePackages.bash-language-server rnix-lsp # LSP servers
    nodejs # Needed for copilot
  ];
}
