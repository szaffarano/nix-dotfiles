{ pkgs, ... }: {
  programs.nixvim = {

    options = {
      conceallevel = 2;
      concealcursor = "nc";
    };

    extraConfigLuaPre = ''
      require('orgmode').setup_ts_grammar()
    '';

    extraConfigLua = builtins.readFile ./orgmode.lua;

    # TODO: do I need 'akinsho/org-bullets.nvim'?
    extraPlugins = with pkgs.vimPlugins; [
      orgmode
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
