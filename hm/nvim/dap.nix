# DAP configuration

{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.nvim-dap;
      type = "lua";
      config = # lua
        ''
          local dap = require('dap')

          dap.adapters.z33 = function(callback, _config)
            callback({ type = "executable", command = "/home/tarneo/fac/5/ase/tp/z33-cli", args = { "dap" } })
          end

          dap.configurations.asm = {
            {
              type = "z33",
              request = "launch",
              name = "Launch Z33 program",
              program = "''${file}",
              entrypoint = function()
                local answer = vim.fn.input("Entrypoint: ", "main")
                -- An omitted entrypoint lets the adapter pick main/start/run/entry.
                return answer ~= "" and answer or nil
                end,
              stopOnEntry = true,
            },
          }
        '';
    }
    {
      plugin = pkgs.vimPlugins.nvim-dap-ui;
      type = "lua";
      config = # lua
        ''
          require("dapui").setup()
        '';
    }
    pkgs.vimPlugins.nvim-nio
  ];
}
