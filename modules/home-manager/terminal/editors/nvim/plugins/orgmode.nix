{ pkgs, ... }:
let
  org-bullets-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "org-bullets.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "208b8519bccbb9b67deee7115fd6587983d279c1";
      sha256 = "sha256-LEI+d9KKnm7ctOBLn3yDHVgoYHd9QrCyd+BXqpj2W98=";
    };
  };
in
{
  programs.nixvim = {

    options = {
      conceallevel = 2;
      concealcursor = "nc";
    };

    extraConfigLuaPre = ''
      require('orgmode').setup_ts_grammar()
    '';

    extraConfigLua = builtins.readFile ./orgmode.lua;

    extraPlugins = with pkgs.vimPlugins; [
      orgmode
      org-bullets-nvim
    ];

    keymaps = [
      {
        key = "<localleader>tt";
        action = "require('orgmode.org.mappings').toggle_checkbox";
        lua = true;
        options = {
          desc = "[T]oggle checkbox (orgmode)";
        };
      }
    ];

    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "org"
        ];
        command = "setlocal nofoldenable";
      }
    ];
  };
}
