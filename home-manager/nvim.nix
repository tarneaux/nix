{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs; [
      {
        plugin = vimPlugins.gruvbox-nvim;
        config = ''
          colorscheme gruvbox
          highlight clear SignColumn
        '';
      }
      (pkgs.vimUtils.buildVimPlugin
        {
          pname = "copilot-lualine";
          version = "2024-01-30";
          src = pkgs.fetchFromGitHub {
            owner = "AndreM222";
            repo = "copilot-lualine";
            rev = "9e226cf8f4653e13ec282f5878d66aa435899c8c";
            sha256 = "sha256-Ma0wpY2Tg0Kr6Epu3QyGesXRjOcugyJ2NTuOUPSLvLk=";
          };
          meta.homepage = "https://github.com/AndreM222/copilot-lualine";
        })
      {
        plugin = vimPlugins.lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              component_separators = {"", ""},
              section_separators = {"", ""},
            },
            sections = {
              lualine_a = {'mode'},
              lualine_b = {'branch', 'diff', 'diagnostics'},
              lualine_c = {'filename'},
              lualine_x = {'copilot', 'encoding', 'fileformat', 'filetype'},
              lualine_y = {'progress'},
              lualine_z = {'location'}
            },
          }
        '';
      }
      {
        plugin = vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('orgmode').setup_ts_grammar()
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
              autotag = {
                enable = true,
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
        plugin = vimPlugins.orgmode;
        type = "lua";
        config = ''
          require('orgmode').setup {
            org_agenda_files = {'~/org/**'},
            org_default_notes_file = '~/org/fast.org',
            org_todo_keywords = {'TODO', 'NEXT', 'DOING', 'WAITING', 'LATER', 'TOREAD', 'TOWRITE', 'DONE'},
            org_hide_emphasis_markers = true,
            org_hide_leading_stars = true,
            org_ellipsis = '  ',
            org_indent_mode = 'noindent',
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
        plugin = vimPlugins.copilot-lua;
        type = "lua";
        config = ''
          require('copilot').setup {
            suggestion = {
              enabled = true,
              auto_trigger = true,
            },
            panel = { enabled = false },
            filetypes = {
              ["*"] = true,
              ["markdown"] = false,
              ["org"] = false,
              ["mail"] = false,
            },
            copilot_node_command = '${pkgs.nodejs-slim}/bin/node',
          }
          -- Using vim.keymap.set doesn't work here for some reason.
          vim.cmd [[ nnoremap <leader>c <cmd>silent Copilot! toggle<cr> ]]
        '';
      }
      {
        plugin = vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          local lspconfig = require('lspconfig')
          local servers = {"clangd", "rust_analyzer", "pyright", "bashls", "html", "jsonls", "rust_analyzer", "lua_ls", "hls", "eslint", "ansiblels", "yamlls", "nil_ls"}

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
              }
          })
        '';
      }
      {
        plugin = vimPlugins.which-key-nvim;
        type = "lua";
        config = ''
          vim.o.timeout = true
          vim.o.timeoutlen = 300
          require('which-key').setup {}
        '';
      }
      vimPlugins.vim-rooter
      {
        plugin = vimPlugins.gitsigns-nvim;
        type = "lua";
        config = ''
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
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp_luasnip
      {
        plugin = vimPlugins.nvim-cmp;
        type = "lua";
        config = ''
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
                elseif require("copilot.suggestion").is_visible() then
                  require("copilot.suggestion").accept()
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
      vimPlugins.friendly-snippets
      {
        plugin = vimPlugins.luasnip;
        type = "lua";
        config = ''
          require('luasnip/loaders/from_vscode').load()
        '';
      }
      vimPlugins.vim-commentary
      {
        plugin = vimPlugins.rust-vim;
        type = "lua";
        config = ''
          vim.g.rustfmt_autosave = 1
        '';
      }
      vimPlugins.vim-table-mode
      {
        # nvim-ufo allows folding with highlighting (as opposed to standard
        # folding which removes the highlighting from the remaining line)
        plugin = vimPlugins.nvim-ufo;
        type = "lua";
        config = ''
          vim.opt.foldenable = true
          require('ufo').setup()
        '';
      }
      vimPlugins.vim-wakatime
      {
        plugin = vimPlugins.telescope-nvim;
        type = "lua";
        config = ''
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
              ["<leader>t"] = {
                  name = "Telescope",
                  f = { "<cmd>Telescope find_files<cr>", "Find files" },
                  g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
                  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
                  h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
                  s = { "<cmd>Telescope git_status<cr>", "Git status" },
                  c = { "<cmd>Telescope git_commits<cr>", "Git commits" },
                  C = { "<cmd>Telescope git_bcommits<cr>", "Git buffer commits" },
                  r = { "<cmd>Telescope registers<cr>", "Registers" },
                  m = { "<cmd>Telescope marks<cr>", "Marks" },
                  e = { "<cmd>Telescope symbols<cr>", "Symbols" },
              }
          })
        '';
      }
      vimPlugins.telescope-symbols-nvim
      vimPlugins.vim-devicons
      vimPlugins.nvim-web-devicons
    ];
    extraLuaConfig = ''
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
          pattern = "nix,yaml,json,markdown,org,html,css,scss",
          callback = function ()
              local w = 2
              vim.opt.tabstop = w
              vim.opt.shiftwidth = w
              vim.opt.softtabstop = w
          end
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
    '';
  };
  # LSP packages
  home.packages = with pkgs; [
    arduino-language-server
    texlab
    pyright
    nodePackages.bash-language-server
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-json-languageserver-bin
    lua-language-server
    haskell-language-server
    ansible-language-server
    yaml-language-server
    nil
  ];
}
