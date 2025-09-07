# Tmux settings

{ pkgs, ... }:
{
  programs.neovim.plugins = [
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
            copy_sync = {
              enable = false -- Don't mess up my clipboard OS sync !
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
}
