{pkgs, ...}:

{
  enable = true;
  defaultEditor = true;
  plugins = with pkgs.vimPlugins; [
    { plugin = gruvbox;
      config = "colorscheme gruvbox";
    }
    { plugin = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "lualine";
        version = "0.1.0";
        src = pkgs.fetchFromGitHub {
            owner = "nvim-lualine";
            repo = "lualine.nvim";
            rev = "0ddacf0";
            hash = "sha256-3ov4cU3+oMcKvsoZ/H/KDqrFxzIxUFMDZ1OC2pO92ZQ=";
        };
      };
      config = ''lua << EOF
          require('lualine').setup()
          EOF'';
    }
  ];
}
