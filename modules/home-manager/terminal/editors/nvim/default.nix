# TODO: parameterize to enable or disable the module
{ pkgs, ... }: {
  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };

  programs.zsh = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

  xdg.dataFile."nvim/templates" = {
    source = ./templates;
    recursive = true;
  };

  home.packages = with pkgs; [
    tree-sitter

    # formatters
    shfmt
    stylua

    # linters
    markdownlint-cli
    golangci-lint
    shellcheck
    hadolint
    vale

    # LSP servers
    gopls
    nil
    nodePackages.typescript-language-server
    lua-language-server
    pyright
    rust-analyzer
    terraform-ls
    yaml-language-server

    # debug
    delve
    lldb
  ];

  xdg.desktopEntries = {
    nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      comment = "Edit text files";
      exec = "nvim %F";
      icon = "nvim";
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      terminal = true;
      type = "Application";
      categories = [ "Utility" "TextEditor" ];
    };
  };
}
