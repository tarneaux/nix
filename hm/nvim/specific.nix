# Settings specific to a language

{ pkgs, ... }:
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

      vim.api.nvim_create_user_command("NewJournalEntry", function ()
        local dir = vim.fn.expand("~/space/journal/" .. vim.fn.strftime("%Y-%m-%d %a"))
        local file = dir .. "/" .. vim.fn.strftime("%H-%M-%S.md")
        vim.fn.mkdir(dir, 'p')
        vim.cmd.edit(file)
      end, {})
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
  ];
  home.packages = with pkgs; [
    surf # For typst preview
  ];
}
