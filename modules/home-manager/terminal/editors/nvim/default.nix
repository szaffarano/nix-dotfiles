# TODO: parameterize to enable or disable the module
{ pkgs
, ...
}:
let
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies ];
  };
  rustSnippets = pkgs.fetchFromGitHub {
    owner = "rust10x";
    repo = "rust10x-vscode";
    rev = "00bd8995003a750e8f44110cbe1ece0c141a962b";
    hash = "sha256-KdpuZflRR1VXarXg7XoPOoK1j2mhhLE4Hi27D4aQwKI=";
  };
in
{
  programs.zsh = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withNodeJs = false;
    withPython3 = false;
    package = pkgs.neovim-unwrapped;
  };

  xdg = {
    configFile = {
      "nvim" = {
        source = ./config;
        recursive = true;
      };
    };

    dataFile = {
      "nvim/rust-snippets" = {
        source = rustSnippets;
      };

      "nvim/treesitter-parsers" = {
        source = treesitter-parsers;
      };
    };
  };

  home = {
    sessionVariables.EDITOR = "nvim";
    custom.allowed-unfree-packages = [ pkgs.codeium ];
    packages = with pkgs; [
      tree-sitter
      fswatch

      # formatters
      asmfmt
      ruff
      nasmfmt
      nixfmt-rfc-style
      prettierd
      shfmt
      stylua

      # linters
      nodePackages.jsonlint
      markdownlint-cli
      golangci-lint
      shellcheck
      hadolint
      vale

      # LSP servers
      asm-lsp
      clang-tools
      codeium
      dockerfile-language-server-nodejs
      gopls
      ltex-ls
      lua-language-server
      nil
      nodePackages.typescript-language-server
      pyright
      rust-analyzer
      terraform-ls
      # TODO: uncomment when the package is fixed vscode-langservers-extracted
      yaml-language-server
      vscode-langservers-extracted
      zls

      # debug
      delve
      gdb
      lldb
    ];
  };

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
