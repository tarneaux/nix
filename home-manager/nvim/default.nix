{
  pkgs,
  username,
  hostname,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [
      {
        plugin = pkgs.vimPlugins.gruvbox-nvim;
        config = # vim
          ''
            colorscheme gruvbox
            highlight clear SignColumn
          '';
      }
      {
        plugin = pkgs.vimPlugins.lualine-nvim;
        type = "lua";
        config = # lua
          ''
            require('lualine').setup {
              options = {
                component_separators = {"", ""},
                section_separators = {"", ""},
              },
              sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },
            }
          '';
      }
      pkgs.vimPlugins.nvim-treesitter-textobjects
      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = # lua
          ''
            require('nvim-treesitter.configs').setup {
              highlight = {
                enable = true,
                autotag = {
                  enable = true,
                },
              },
              textobjects = {
                select = {
                  enable = true,
                  lookahead = true,
                  keymaps = {
                    ["af"] = { query = "@function.outer", desc = "Around function" },
                    ["if"] = { query = "@function.inner", desc = "In function" },
                    ["ac"] = { query = "@class.outer", desc = "Around class" },
                    ["ic"] = { query = "@class.inner", desc = "In class" },
                  },
                  selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                  },
                },
              },
            }

            -- Enable folding using treesitter
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldlevel = 99
          '';
      }
      {
        plugin = pkgs.vimPlugins.orgmode;
        type = "lua";
        config = # lua
          ''
            require('orgmode').setup {
              org_agenda_files = {'~/org/**'},
              org_default_notes_file = '~/org/fast.org',
              org_todo_keywords = {'TODO', 'NEXT', 'DOING', 'WAITING', 'LATER', 'TOREAD', 'TOWRITE', 'DONE'},
              org_hide_emphasis_markers = true,
              org_hide_leading_stars = true,
              org_ellipsis = '  ',
              org_startup_indented = false,
              org_archive_location = "~/org/archive.org::/",
              org_blank_before_new_entry = {heading = false, plain_list_item = false},
            }
            vim.api.nvim_create_autocmd("Filetype", {
                pattern = "org",
                callback = function ()
                    vim.opt.conceallevel = 3
                end
            })
          '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = # lua
          ''
            local lspconfig = require('lspconfig')
            local servers = {"clangd", "rust_analyzer", "pyright", "bashls", "html", "jsonls", "rust_analyzer", "lua_ls", "hls", "eslint", "ansiblels", "yamlls", "nil_ls", "gopls", "texlab"}

            cap = require('cmp_nvim_lsp').default_capabilities()

            -- The following is needed for nvim-ufo (folding) to work
            cap.textDocument.foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }

            for _, lsp in ipairs(servers) do
              lspconfig[lsp].setup {
                capabilities = cap,
              }
            end

            -- arduino_language_server specific setup
            lspconfig.arduino_language_server.setup{
                cmd = { "arduino-language-server", "--fqbn", "esp32:esp32:XIAO_ESP32C3" },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }

            -- texlab specific setup
            lspconfig.texlab.setup{
                cmd = { "texlab" },
                filetypes = { "tex", "bib", "markdown" },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }

            require("which-key").register({
                ["<leader>l"] = {
                    name = "LSP actions",
                    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action" },
                    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
                    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
                    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
                    r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to references" },
                    R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
                    h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
                    H = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
                    s = { "<cmd>lua vim.lsp.buf.document_symbol()<cr>", "Document symbols" },
                    S = { "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", "Workspace symbols" },
                    t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition" },
                    x = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Show line diagnostics" },
                    f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format buffer" },
                }
            })
          '';
      }
      {
        plugin = pkgs.vimPlugins.which-key-nvim;
        type = "lua";
        config = # lua
          ''
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {}
          '';
      }
      pkgs.vimPlugins.vim-rooter
      {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config = # lua
          ''
            require('gitsigns').setup {
              signs = {
                add          = { text = '+' },
                change       = { text = '±' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
              },
            }
          '';
      }
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp_luasnip
      {
        plugin = pkgs.vimPlugins.nvim-cmp;
        type = "lua";
        config = # lua
          ''
            local cmp = require("cmp")
            local has_words_before = function()
              if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
              local line, col = unpack(vim.api.nvim_win_get_cursor(0))
              return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
            end
            cmp.setup({
              snippet = {
                expand = function(args)
                  require("luasnip").lsp_expand(args.body)
                end,
              },
              window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
              mapping = {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.close(),
                ["<C-space>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = true,
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                  local luasnip = require("luasnip")
                  if cmp.visible() and has_words_before() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, {"i", "s"}),
              },
              sources = {
                { name = "nvim_lsp" },
                { name = "orgmode" },
                { name = "buffer" },
                { name = "luasnip" }
              },
            })
          '';
      }
      pkgs.vimPlugins.friendly-snippets
      {
        plugin = pkgs.vimPlugins.luasnip;
        type = "lua";
        config = # lua
          ''
            require('luasnip/loaders/from_vscode').load()
          '';
      }
      {
        plugin = pkgs.vimPlugins.vim-commentary;
        config = # vim
          ''
            autocmd FileType nix setlocal commentstring=#\ %s
          '';
      }
      {
        plugin = pkgs.vimPlugins.rust-vim;
        type = "lua";
        config = # lua
          ''
            vim.g.rustfmt_autosave = 1
          '';
      }
      {
        plugin = pkgs.vimPlugins.vim-table-mode;
        type = "lua";
        config = # lua
          ''
            vim.api.nvim_create_autocmd("Filetype", {
                pattern = "markdown,org",
                callback = function() vim.cmd [[ :silent TableModeEnable ]] end,
            })
          '';
      }
      {
        # nvim-ufo allows folding with highlighting (as opposed to standard
        # folding which removes the highlighting from the remaining line)
        plugin = pkgs.vimPlugins.nvim-ufo;
        type = "lua";
        config = # lua
          ''
            vim.opt.foldenable = true
            require('ufo').setup()
          '';
      }
      pkgs.vimPlugins.vim-wakatime
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        type = "lua";
        config = # lua
          ''
            local telescope = require('telescope')
            telescope.setup {
              defaults = {
                mappings = {
                  i = {
                    ["<esc>"] = require('telescope.actions').close,
                  },
                },
              },
            }
            require('which-key').register({
                ["<leader>f"] = {
                    name = "Find",
                    f = { "<cmd>Telescope find_files<cr>", "Find files" },
                    g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
                    h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
                    s = { "<cmd>Telescope git_status<cr>", "Git status" },
                    c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
                    C = { "<cmd>Telescope git_bcommits<cr>", "Git buffer commits" },
                    r = { "<cmd>Telescope registers<cr>", "Registers" },
                    m = { "<cmd>Telescope marks<cr>", "Marks" },
                    e = { "<cmd>Telescope symbols<cr>", "Symbols" },
                },
                [","] = {
                  "<cmd>Telescope buffers<cr>",
                  "Switch buffer"
                }
            })
          '';
      }
      pkgs.vimPlugins.telescope-symbols-nvim
      pkgs.vimPlugins.vim-devicons
      pkgs.vimPlugins.nvim-web-devicons
      {
        plugin = pkgs.vimPlugins.go-nvim;
        type = "lua";
        config = # lua
          ''
            require('go').setup {}

            local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = "*.go",
              callback = function()
               require('go.format').goimport()
              end,
              group = format_sync_grp,
            })
          '';
      }
      pkgs.vimPlugins.trouble-nvim
      pkgs.vimPlugins.vim-surround
      {
        plugin = pkgs.vimPlugins.leap-nvim;
        type = "lua";
        config = # lua
          ''
            require('leap').create_default_mappings()
          '';
      }
      pkgs.vimPlugins.undotree
      {
        plugin = pkgs.vimPlugins.todo-comments-nvim;
        type = "lua";
        config = # lua
          ''
            require('todo-comments').setup {}
          '';
      }
    ];
    extraLuaConfig = # lua
      ''
        -- Leader = space
        vim.g.mapleader = " "

        -- Enable relative line numbers
        vim.opt.number = true
        vim.opt.relativenumber = true

        -- Show gutter in line numbers

        -- Disable those annoying swap files
        vim.opt.swapfile = false

        -- Store undo history between sessions
        vim.opt.undofile = true
        vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

        -- Use four spaces for indentation (tabs)
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true

        -- Use two spaces for indentation in some filetypes where it's the
        -- convention
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "nix,yaml,json,markdown,org,html,css,scss,arduino,lisp",
            callback = function ()
                local w = 2
                vim.opt.tabstop = w
                vim.opt.shiftwidth = w
                vim.opt.softtabstop = w
            end
        })

        -- Use tab for indentation in Go
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "go",
            callback = function () vim.opt.expandtab = false end
        })

        -- Enable mouse support just in case I turn into a normie (magic!)
        vim.opt.mouse = "a"

        -- Enable system clipboard support
        vim.opt.clipboard = "unnamedplus"

        -- Word wrap
        vim.opt.wrap = true
        vim.opt.linebreak = true

        vim.opt.scrolloff = 2

        -- Add french to spellcheck and keep english
        -- For this we need to add the classic vim RTP (for neovim to find the spell files)
        vim.opt.runtimepath:append("/usr/share/vim/vimfiles/")

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown,org",
            callback = function ()
                vim.opt.spelllang:append("fr")
            end
        })

        -- When editing a git commit message, org or markdown file, enable spellcheck
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "gitcommit,markdown,org",
            callback = function ()
                vim.opt.spell = true
            end
        })

        -- When editing a git commit message, set the textwidth and colorcolumn to the recommended values
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "gitcommit",
            callback = function ()
                vim.opt.textwidth = 72
                vim.opt.colorcolumn = "73"
            end
        })

        -- python formatter
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "python",
            callback = function ()
                vim.keymap.set("n", "<leader>f", ":!black %<cr>", {desc = "Format python file"})
            end
        })

        -- <leader>e to open netrw
        vim.keymap.set("n", "<leader>e", ":Explore<cr>", {desc = "Open netrw"})

        -- <leader>O to set options
        require('which-key').register({
          ["<leader>O"] = {
            name = "Options",
            t = {
              function ()
                if vim.opt.tabstop:get() == 4 then
                  vim.opt.tabstop = 2
                  vim.opt.shiftwidth = 2
                  vim.opt.softtabstop = 2
                else
                  vim.opt.tabstop = 4
                  vim.opt.shiftwidth = 4
                  vim.opt.softtabstop = 4
                end
              end,
              "Toggle tab width (2/4)"
            },
            c = {
              function ()
                if vim.opt.colorcolumn:get()[1] == "81" then
                  vim.opt.colorcolumn = ""
                else
                  vim.opt.colorcolumn = "81"
                end
                if vim.opt.textwidth:get() == 0 then
                  vim.opt.textwidth = vim.opt.colorcolumn:get()[1] - 1
                end
              end,
              "Toggle colorcolumn (81/none)"
            },
            w = {
              function ()
                if vim.opt.textwidth:get() == 0 then
                  vim.opt.textwidth = vim.opt.colorcolumn:get()[1] - 1
                else
                  vim.opt.textwidth = 0
                end
              end,
              "Toggle textwidth (colorcolumn-1/none)",
            },
          },
        })

        -- <leader>s to search and replace
        vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]], {desc = "Search and replace"})
        -- Case insensitive
        vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc = "Search and replace (case insensitive)"})

        -- <leader>p to paste in visual & select modes without changing the register
        vim.keymap.set("x", "<leader>p", '"_dP', {desc = "Paste without changing register"})

        -- Shift+Up/Down to move lines
        vim.keymap.set("n", "<S-Up>", "<cmd>m .-2<cr>==")
        vim.keymap.set("n", "<S-Down>", "<cmd>m .+1<cr>==")

        -- Shift+Up/Down to move selected lines in visual mode
        vim.keymap.set("x", "<S-Up>", ":move'<-2<CR>gv=gv")
        vim.keymap.set("x", "<S-Down>", ":move'>+1<CR>gv=gv")

        -- Add signature at bottom of email files
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "mail",
            callback = function ()
                vim.keymap.set("n", ",s", function () vim.cmd [[ :r ~/.config/aerc/signature.txt ]] end, { buffer = true })
            end
        })

        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "mail",
            callback = function ()
                vim.keymap.set("n", ",u", function () vim.cmd [[ :r ~/.config/aerc/signature_univ.txt ]] end, { buffer = true })
            end
        })

        vim.g.pyindent_open_paren = "shiftwidth()"

        -- Enable colorcolumn in all files
        vim.opt.colorcolumn = "81"

        -- And disable it in some filetypes
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "gitcommit,md,org",
            callback = function ()
                vim.opt.colorcolumn = "81"
            end
        })

        require('which-key').register ({
          ['<leader>t'] = {
            name = "Tabs",
            n = { "<cmd>tabnew<cr>", "New tab" },
            c = { "<cmd>tabclose<cr>", "Close tab" },
            e = { "<cmd>tabnext<cr>", "Next tab" },
            i = { "<cmd>tabprevious<cr>", "Previous tab" },
          }
        })
      '';
  };
  # LSP packages
  home.packages = with pkgs; [
    arduino-language-server
    texlab
    pyright
    nodePackages.bash-language-server
    shellcheck
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver-bin
    lua-language-server
    libclang
    haskell-language-server
    ansible-language-server
    yaml-language-server
    nil
    unstable.vscode-langservers-extracted
    vscode-extensions.sumneko.lua
    gopls
    texlab
    tree-sitter
    nodejs_22
    nixd
    nixfmt-rfc-style
  ];
}
