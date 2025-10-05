# Settings useful for all files.

{ pkgs, lib, ... }:
{
  programs.neovim.extraLuaConfig =
    lib.mkBefore # lua
      ''
        vim.g.mapleader = "<space>"
        vim.opt.mouse = "a"

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

        -- Set the default register to the system clipboard
        vim.opt.clipboard = "unnamedplus"

        -- Word wrap
        vim.opt.wrap = true
        vim.opt.linebreak = true

        vim.opt.scrolloff = 2

        -- Add the classic vim RTP for neovim to find the spell files
        -- See specific.nix for other spellcheck options
        vim.opt.runtimepath:append("/usr/share/vim/vimfiles/")

        vim.keymap.set("x", "<leader>p", '"_dP', {desc = "Paste without changing register"})

        -- move lines
        vim.keymap.set("n", "<S-Up>", "<cmd>m .-2<cr>")
        vim.keymap.set("n", "<S-Down>", "<cmd>m .+1<cr>")
        -- Shift+Up/Down to move selected lines in visual mode
        vim.keymap.set("x", "<S-Up>", ":move'<-2<CR>gv")
        vim.keymap.set("x", "<S-Down>", ":move'>+1<CR>gv")

        -- Enable colorcolumn, is disabled for some ft's in specific.nix
        vim.opt.colorcolumn = "81"
      '';
  programs.neovim.plugins = lib.mkBefore [
    pkgs.vimPlugins.vim-rooter
    pkgs.vimPlugins.vim-wakatime
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.undotree
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
    {
      plugin = pkgs.vimPlugins.gitsigns-nvim;
      type = "lua";
      config = # lua
        ''
          require('gitsigns').setup()
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
      plugin = pkgs.vimPlugins.leap-nvim;
      type = "lua";
      config = # lua
        ''
          require('leap').create_default_mappings()
        '';
    }
    {
      plugin = pkgs.vimPlugins.todo-comments-nvim;
      type = "lua";
      config = # lua
        ''
          require('todo-comments').setup {}
        '';
    }
    {
      plugin = pkgs.vimPlugins.oil-nvim;
      type = "lua";
      config = # lua
        ''
          require("oil").setup {
            view_options = {
              show_hidden = true,
            },
          }
          vim.keymap.set("n", "-", ":Oil<cr>", {desc = "Open parent directory"})
        '';
    }
  ];
}
