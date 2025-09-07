# LSP and treesitter configuration

{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      type = "lua";
      config = # lua
        ''
          require('nvim-treesitter.configs').setup {
            highlight = {
              enable = true,
              autotag = {
                enable = true, -- for HTML tags
              },
            },
          }
        '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-lspconfig;
      type = "lua";
      config = # lua
        ''
          local lspconfig = require('lspconfig')

          vim.lsp.enable({
            "ansiblels",
            "arduino_language_server",
            "bashls",
            "clangd",
            "eslint",
            "gopls",
            "hls",
            "html",
            "jsonls",
            "lua_ls",
            "nixd",
            "pyright",
            "texlab",
            "tinymist",
            "yamlls",
          })

          cap = require('cmp_nvim_lsp').default_capabilities()
          vim.lsp.config('*', { capabilities = cap })
          vim.lsp.inlay_hint.enable()

          -- Language-specific configs are in specific.nix

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
              { "<leader>ln", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next diagnostic" },
              { "<leader>lN", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Previous diagnostic" },
          })
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
            mapping = {
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
      plugin = pkgs.vimPlugins.trouble-nvim;
      type = "lua";
      config = # lua
        ''
          require('trouble').setup {}
        '';
    }
  ];
  home.file.".config/nvim/snippets/".source = ./snippets;

  home.packages = with pkgs; [
    arduino-language-server
    texlab
    pyright
    nodePackages.bash-language-server
    shellcheck
    vscode-langservers-extracted
    vscode-extensions.sumneko.lua
    lua-language-server
    libclang
    haskell-language-server
    ansible-language-server
    yaml-language-server
    gopls
    texlab
    tree-sitter
    nixd
    nixfmt-rfc-style
    tinymist # Typst LSP
  ];
}
