# TODO: parameterize to enable or disable the module
{ pkgs, ... }:
let
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies ];
  };
  rustSnippets = pkgs.fetchFromGitHub {
    owner = "rust10x";
    repo = "rust10x-vscode";
    rev = "94e8b98";
    hash = "sha256-4aA5QcaX+lA3S/d0R/aHX/W2wxhvMxaLd7/hmrvp4P8=";
  };
in
{
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

  xdg.dataFile."nvim/rust-snippets" = {
    source = rustSnippets;
  };

  xdg.dataFile."nvim/templates" = {
    source = ./templates;
    recursive = true;
  };

  xdg.dataFile."nvim/treesitter-parsers" = {
    source = treesitter-parsers;
  };

  home.packages = with pkgs; [
    tree-sitter
    fswatch

    # formatters
    shfmt
    stylua
    black
    isort
    prettierd
    nixfmt-rfc-style

    # linters
    nodePackages.jsonlint
    markdownlint-cli
    golangci-lint
    shellcheck
    hadolint
    vale

    # LSP servers
    clang-tools
    codeium
    gopls
    lua-language-server
    ltex-ls
    nil
    nodePackages.typescript-language-server
    pyright
    rust-analyzer
    terraform-ls
    vscode-langservers-extracted
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
      categories = [
        "Utility"
        "TextEditor"
      ];
    };
  };
}
