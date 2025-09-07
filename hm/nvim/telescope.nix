{ pkgs, ... }:
{
  programs.neovim.plugins = [
    pkgs.vimPlugins.telescope-symbols-nvim
    pkgs.vimPlugins.vim-devicons
    pkgs.vimPlugins.nvim-web-devicons
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

          -- Wrap lines in preview
          vim.api.nvim_create_autocmd("User", {
              pattern = "TelescopePreviewerLoaded",
              callback = function(args) vim.wo.wrap = true end,
          })

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
              { ",,", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
          })
        '';
    }
  ];
}
