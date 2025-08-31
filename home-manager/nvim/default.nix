{
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    package = pkgs.unstable.neovim-unwrapped;
    plugins = [
      {
        plugin = pkgs.vimPlugins.gruvbox-nvim;
        type = "lua";
        config = # lua
          ''
            vim.o.background = "dark"
            require('gruvbox').setup {}
            vim.cmd.colorscheme('gruvbox')
            vim.cmd.highlight("clear SignColumn")
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
                lualine_x = {'filetype'},
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
              org_ellipsis = ' ===',
              org_startup_indented = false,
              org_archive_location = "~/org/archive.org::/",
              org_blank_before_new_entry = {heading = false, plain_list_item = false},
            }
          '';
      }
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = # lua
          ''
            local lspconfig = require('lspconfig')
            local servers = {"clangd", "pyright", "bashls", "html", "jsonls", "lua_ls", "hls", "eslint", "ansiblels", "yamlls", "nil_ls", "gopls", "texlab"}

            cap = require('cmp_nvim_lsp').default_capabilities()

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

            vim.lsp.inlay_hint.enable()

            require("which-key").add({
                { "<leader>l", group = "LSP actions" },
                { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code action" },
                { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to definition" },
                { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to declaration" },
                { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Go to implementation" },
                { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Go to references" },
                { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
                { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
                { "<leader>lH", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature help" },
                { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to type definition" },
                { "<leader>lx", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show line diagnostics"},
                { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", desc = "Format buffer" },
            })
            require('which-key').add({
                { ",n", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Go to next diagnostic" },
                { ",N", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Go to previous diagnostic" },
            })
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
        plugin = pkgs.vimPlugins.rustaceanvim;
        type = "lua";
        config = # lua
          ''
            vim.g.rustaceanvim = {
                tools = {},
                server = {
                    on_attach = function(client, bufnr)
                    end,
                    default_settings = {
                      -- rust-analyzer language server configuration
                      ['rust-analyzer'] = {
                        diagnostic = {
                          enable = true,
                          refreshSupport = true,
                        },
                      },
                    },
                },
                dap = {},
            }
            require('which-key').add({
              { "<leader>r", group = "Rust"},
              { "<leader>re", "<cmd>RustLsp expandMacro<cr>", desc = "Expand macro" },
              { "<leader>ra", "<cmd>RustLsp codeAction<cr>", desc = "Code actions including categories" },
              { "<leader>rx", "<cmd>RustLsp renderDiagnostic<cr>", desc = "Display rendered diagnostic"},
              { "<leader>rr", "<cmd>RustLsp relatedDiagnostics<cr>", desc = "Go to related diagnostic"},
              { "<leader>rd", "<cmd>RustLsp openDocs<cr>", desc = "Go to symbol documentation" },
              { "<leader>rj", "<cmd>RustLsp joinLines<cr>", desc = "Join lines" },
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
            require('gitsigns').setup()
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
      pkgs.vimPlugins.vim-snipmate
      pkgs.vimPlugins.vim-snippets
      {
        plugin = pkgs.vimPlugins.luasnip;
        type = "lua";
        config = # lua
          ''
            require('luasnip/loaders/from_snipmate').load()
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

            local colors = require('gruvbox').palette
            local TelescopeColor = {
              TelescopeMatching = { fg = colors.bright_yellow },
              TelescopeSelection = { fg = colors.light0, bg = colors.dark1, bold = true },

              TelescopeNormal = { bg = colors.dark1 },
              TelescopePromptPrefix = { link = "TelescopeNormal" },
              TelescopePromptNormal = { link = "TelescopeNormal" },
              TelescopeResultsNormal = { link = "TelescopeNormal" },
              TelescopePreviewNormal = { link = "TelescopeNormal" },

              TelescopeBorder = { bg = colors.dark1, fg = colors.dark1 },
              TelescopePromptBorder = { link = "TelescopeBorder" },
              TelescopeResultsBorder = { link = "TelescopeBorder" },
              TelescopePreviewBorder = { link = "TelescopeBorder" },

              TelescopeTitle = { bg = colors.light4, fg = colors.dark0 },
              TelescopeResultsTitle = { link = "TelescopeTitle" },
              TelescopePreviewTitle = { link = "TelescopeTitle" },
              TelescopePromptTitle = { bg = colors.neutral_yellow, fg = colors.dark0, bold = true },
            }

            for hl, col in pairs(TelescopeColor) do
              vim.api.nvim_set_hl(0, hl, col)
            end

            require('which-key').add({
                { "<leader>f", group = "Find" },
                { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
                { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
                { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
                { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
                { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
                { "<leader>fC", "<cmd>Telescope git_bcommits<cr>", desc = "Git buffer commits" },
                { "<leader>fr", "<cmd>Telescope registers<cr>", desc = "Registers" },
                { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
                { "<leader>fe", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
                { "<leader>f,", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
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
      {
        plugin = pkgs.vimPlugins.trouble-nvim;
        type = "lua";
        config = # lua
          ''
            require('trouble').setup {}
          '';
      }
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
      {
        plugin = pkgs.vimPlugins.tmux-nvim;
        type = "lua";
        config = # lua
          ''
            require('tmux').setup {
              navigation = {
                enable_default_keybindings = false,
                cycle_navigation = false,
              },
              resize = {
                enable_default_keybindings = false,
              },
              swap = {
                enable_default_keybindings = false,
              },
            }
            local tmux_keymaps = require("tmux.keymaps")
            tmux_keymaps.register("n", {
              ["<A-n>"] = [[<cmd>lua require'tmux'.move_left()<cr>]],
              ["<A-e>"] = [[<cmd>lua require'tmux'.move_top()<cr>]],
              ["<A-i>"] = [[<cmd>lua require'tmux'.move_bottom()<cr>]],
              ["<A-o>"] = [[<cmd>lua require'tmux'.move_right()<cr>]],

              ["<C-A-n>"] = [[<cmd>lua require'tmux'.resize_left()<cr>]],
              ["<C-A-e>"] = [[<cmd>lua require'tmux'.resize_top()<cr>]],
              ["<C-A-i>"] = [[<cmd>lua require'tmux'.resize_bottom()<cr>]],
              ["<C-A-o>"] = [[<cmd>lua require'tmux'.resize_right()<cr>]],

              ["<A-S-n>"] = [[<cmd>lua require'tmux'.swap_left()<cr>]],
              ["<A-S-e>"] = [[<cmd>lua require'tmux'.swap_top()<cr>]],
              ["<A-S-i>"] = [[<cmd>lua require'tmux'.swap_bottom()<cr>]],
              ["<A-S-o>"] = [[<cmd>lua require'tmux'.swap_right()<cr>]],
            })
          '';
      }
    ];
    extraLuaConfig = # lua
      ''
        -- Basic options
        vim.g.mapleader = " "
        vim.opt.mouse = "a"
        vim.opt.number = true
        vim.opt.relativenumber = true
        -- sidecar files
        vim.opt.swapfile = false
        vim.opt.undofile = true
        vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

        -- Indentation options
        -- default
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true
        -- others
        function set_tw(w)
            vim.opt_local.tabstop = w
            vim.opt_local.shiftwidth = w
            vim.opt_local.softtabstop = w
        end
        -- 2 space indentation
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "nix,yaml,json,markdown,org,html,css,scss,arduino,lisp",
            callback = function () set_tw(2) end
        })
        -- 1 space indentation
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "tex",
            callback = function () set_tw(1) end
        })
        -- tab indentation
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "go,snippets",
            callback = function () vim.opt_local.expandtab = false end
        })

        -- Enable system clipboard support
        vim.opt.clipboard = "unnamedplus"

        -- Word wrap
        vim.opt.wrap = true
        vim.opt.linebreak = true

        vim.opt.scrolloff = 2

        -- Spellcheck
        -- Add the classic vim RTP (for neovim to find the spell files)
        vim.opt.runtimepath:append("/usr/share/vim/vimfiles/")
        -- Where to enable checking
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "gitcommit,markdown,org",
            callback = function ()
                vim.opt.spell = true
            end
        })
        -- Where to enable French too
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown,org",
            callback = function ()
                vim.opt.spelllang:append("fr")
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

        -- Conceal some stuff in org and markdown
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "org,markdown",
            callback = function ()
                vim.opt_local.conceallevel = 3
            end
        })

        -- <leader>e to open netrw
        vim.keymap.set("n", "<leader>e", ":Explore<cr>", {desc = "Open netrw"})

        -- <leader>T to insert a title (confuses screen readers, only for private stuff !)
        vim.keymap.set("n", "<leader>T", function ()
            local text = vim.fn.input("Title text: ")

            -- Use awk to print length since Lua counts ANSI commands
            local llen_handle = io.popen("toilet -f future '" .. text .. "' | awk '{ print length }'")
            if llen_handle == nil then return end

            local maxlen = 0
            for line in llen_handle:read("*a"):gmatch("([^\n]+)\n?") do
                 maxlen = math.max(maxlen, tonumber(line))
            end
            llen_handle:close()

            local toilet_handle = io.popen("toilet -f future '" .. text .. "' | sed -e 's/[[:space:]]*$//'")
            if toilet_handle == nil then return end

            local padding = string.rep(" ", math.max(math.floor(40-maxlen/2), 0))
            local out_lines = {}
            for line in toilet_handle:read("*a"):gmatch("([^\n]+)\n?") do
                out_lines[#out_lines + 1] = padding .. line
            end
            toilet_handle:close()

            vim.api.nvim_put(out_lines, "l", true, true)
        end, { desc = "Insert title" })

        -- <leader>O to set options
        require('which-key').add({
          { "<leader>O", group = "Options" },
          { 
            "<leader>Ot",
            function ()
              if vim.opt.tabstop:get() == 4 then
                set_tw(2)
              else
                set_tw(4)
              end
            end,
            desc = "Toggle tab width (2/4)"
          },
          {
            "<leader>Oc",
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
            desc = "Toggle colorcolumn (81/none)"
          },
          {
            "<leader>Ow",
            function ()
              if vim.opt.textwidth:get() == 0 then
                vim.opt.textwidth = vim.opt.colorcolumn:get()[1] - 1
              else
                vim.opt.textwidth = 0
              end
            end,
            desc = "Toggle textwidth (colorcolumn-1/none)",
          },
        })

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

        require('which-key').add ({
          { "<leader>t", group = "Tabs"},
          { "<leader>tn", "<cmd>tabnew<cr>", desc = "New tab" },
          { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close tab" },
          { "<leader>te", "<cmd>tabnext<cr>", desc = "Next tab" },
          { "<leader>ti", "<cmd>tabprevious<cr>", desc = "Previous tab" },
        })

        vim.api.nvim_create_user_command("ZettelkastenQuickNote", function ()
          local dir = vim.fn.expand("~/space/journal/" .. vim.fn.strftime("%Y-%m-%d %a"))
          local file = dir .. "/" .. vim.fn.strftime("%H-%M-%S.md")
          vim.fn.mkdir(dir, 'p')
          vim.cmd.edit(file)
        end, {})
      '';
  };
  # LSP packages
  home.packages = with pkgs; [
    arduino-language-server
    texlab
    pyright
    nodePackages.bash-language-server
    shellcheck
    vscode-langservers-extracted
    lua-language-server
    libclang
    haskell-language-server
    ansible-language-server
    yaml-language-server
    nil
    vscode-extensions.sumneko.lua
    gopls
    texlab
    tree-sitter
    nixd
    nixfmt-rfc-style
  ];
  home.file.".config/nvim/snippets/".source = ./snippets;
}
