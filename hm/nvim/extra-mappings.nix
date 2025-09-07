{ ... }:
{
  programs.neovim.extraLuaConfig = # lua
    ''
      require('which-key').add ({
        { "<leader>t", group = "Tabs"},
        { "<leader>tn", "<cmd>tabnew<cr>", desc = "New tab" },
        { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close tab" },
        { "<leader>te", "<cmd>tabnext<cr>", desc = "Next tab" },
        { "<leader>ti", "<cmd>tabprevious<cr>", desc = "Previous tab" },
      })

      -- Insert an ascii title (confuses screen readers, only for private stuff !)
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
      end, { desc = "Insert ASCII title" })

      -- Set various options
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
    '';
}
