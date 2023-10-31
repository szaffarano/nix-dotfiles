{ pkgs, ... }:
let
  org-bullets-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "org-bullets.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "akinsho";
      repo = "org-bullets.nvim";
      rev = "6e0d60e901bb939eb526139cb1f8d59065132fd9";
      sha256 = "sha256-x6S4WdgfUr7HGEHToSDy3pSHEwOPQalzWhBUipqMtnw=";
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
