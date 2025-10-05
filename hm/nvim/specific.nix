# Settings specific to a language

{ pkgs, user_at_host, ... }:
{
  programs.neovim.extraLuaConfig = # lua
    ''
      -- indentation
      function set_tw(w)
          vim.opt_local.tabstop = w
          vim.opt_local.shiftwidth = w
          vim.opt_local.softtabstop = w
      end
      -- 2 spaces
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "nix,yaml,json,markdown,org,html,css,scss,arduino,lisp",
          callback = function () set_tw(2) end
      })
      -- 1 space
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "tex",
          callback = function () set_tw(1) end
      })
      -- tabs
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "go,snippets",
          callback = function () vim.opt_local.expandtab = false end
      })

      -- spellcheck locations
      vim.api.nvim_create_autocmd("FileType", {
          pattern = "gitcommit,markdown,org",
          callback = function () vim.opt_local.spell = true end
      })
      -- where to allow french in spellcheck
      vim.api.nvim_create_autocmd("FileType", {
          pattern = "markdown,org",
          callback = function () vim.opt_local.spelllang:append("fr") end
      })

      -- When editing a git commit message, set the textwidth and colorcolumn to the recommended values
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "gitcommit",
          callback = function ()
              vim.opt_local.textwidth = 72
              vim.opt_local.colorcolumn = "73"
          end
      })

      -- python formatter
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "python",
          callback = function ()
              vim.keymap.set("n", "<leader>f", ":!black %<cr>", {desc = "Format python file"})
          end
      })

      vim.g.pyindent_open_paren = "shiftwidth()"

      -- Conceal some stuff in org and markdown
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "org,markdown",
          callback = function ()
              vim.opt_local.conceallevel = 3
          end
      })

      -- Add signature at bottom of email files
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "mail",
          callback = function ()
              vim.keymap.set("n", ",s", function ()
                vim.cmd [[ :r ~/.config/aerc/signature.txt ]]
              end, { buffer = true })
              vim.keymap.set("n", ",u", function ()
                vim.cmd [[ :r ~/.config/aerc/signature_univ.txt ]]
              end, { buffer = true })
          end
      })

      -- disable colorcolumn in some places
      vim.api.nvim_create_autocmd("Filetype", {
          pattern = "markdown,org",
          callback = function ()
              vim.opt_local.colorcolumn = "0"
          end
      })

      vim.lsp.config('arduino_language_server', {
          cmd = { "arduino-language-server", "--fqbn", "esp32:esp32:XIAO_ESP32C3" },
      })
      vim.lsp.config('texlab', {
          cmd = { "texlab" },
          filetypes = { "tex", "bib", "markdown" },
      })
      vim.lsp.config('nixd', {
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixfmt" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
              },
              home_manager = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."${user_at_host}".options',
              },
            },
          },
        },
      })
    '';
  programs.neovim.plugins = [
    #                             =========
    #                              orgmode
    #                             =========
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

    #                                 ======
    #                                  rust
    #                                 ======
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

    #                               ==========
    #                                markdown
    #                               ==========
    {
      plugin = pkgs.vimPlugins.markdown-nvim;
      type = "lua";
      config = # lua
        ''
          require("markdown").setup {}
        '';
    }
    pkgs.vimPlugins.markdown-preview-nvim
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

    #                                  ====
    #                                   go
    #                                  ====
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

    #                               =======
    #                                typst
    #                               =======
    {
      plugin = pkgs.vimPlugins.typst-preview-nvim;
      type = "lua";
      config = # lua
        ''
          require("typst-preview").setup {
             open_cmd = "surf -m %s",
          }
          vim.keymap.set("n", "<leader>p", ":TypstPreview<cr>", {desc = "Open typst preview"})
        '';
    }

    #                            ==============
    #                             zettelkasten
    #                            ==============
    {
      plugin = pkgs.vimPlugins.zk-nvim;
      type = "lua";
      config = # lua
        ''
          require("zk").setup {
            picker = "telescope",
          }

          require('which-key').add({
            { "<leader>z", group = "Zk"},
            { "<leader>ze", "<cmd>ZkNotes { excludeHrefs = { 'journal' } }<cr>", desc = "Go to note" },
            { "<leader>zi", "<cmd>ZkInsertLink { excludeHrefs = { 'journal' } }<cr>", desc = "Insert link" },
            { "<leader>zb", "<cmd>ZkBacklinks<cr>", desc = "Backlinks" },
            { "<leader>zt", "<cmd>ZkTags<cr>", desc = "Tags" },
            { "<leader>zn", ":ZkNewFromTitleSelection<cr>", desc = "New with title", mode = "v" },
            { "<leader>zN", ":ZkNewFromContentSelection<cr>", desc = "New with content", mode = "v" },
          })
        '';
    }
  ];
  home.packages = with pkgs; [
    surf # For typst preview
  ];
}
