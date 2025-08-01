# TODO: parameterize to enable or disable the module
{
  pkgs,
  config,
  lib,
  ...
}: let
  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = [pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies];
  };
  rustSnippets =
    pkgs.runCommand "patched-rust10x-vscode" {
      nativeBuildInputs = [pkgs.fixjson pkgs.jq];
      src = pkgs.fetchFromGitHub {
        owner = "rust10x";
        repo = "rust10x-vscode";
        rev = "b5917ecaf69200f62297dd5e4a29ea6e27f3790f";
        hash = "sha256-EgpOrLyhZw0V7caUykO/vMZd7kVh4XpulOhntxDi2k0=";
      };
    } ''
      mkdir -p $out/rust

      find $src/snippets/ -type f | while read -r file; do
        name=$(basename "$file")
        fixjson "$file" | jq . > "$out/rust/$name.json"
      done
    '';
  codelldb = pkgs.writeShellApplication {
    name = "codelldb";
    meta = {
      description = ''
        Wrapper for the CodeLLDB adapter that relies on the system's Python
        environment for execution.
        If a mise setup is detected, it will use the python@system setup to
        avoid mise setup that don't work in Nix.
      '';
    };
    runtimeInputs = [pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter pkgs.python3];
    text = ''
      if mise --version > /dev/null 2>&1; then
        mise exec python@system -- codelldb "$@"
      else
        codelldb "$@"
      fi
    '';
  };
in {
  programs = {
    zsh = lib.mkIf config.programs.zsh.enable {
      sessionVariables = {
        EDITOR = "nvim";
      };
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };
    fish = lib.mkIf config.programs.fish.enable {
      shellInit = ''
        set -gx EDITOR nvim
        set -gx SUDO_EDITOR nvim
      '';
      shellAliases = {
        vim = "nvim";
        vi = "nvim";
        v = "nvim";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      withRuby = false;
      withNodeJs = false;
      withPython3 = false;
      package = pkgs.neovim-unwrapped;
    };
  };

  xdg = {
    configFile = {
      "nvim" = {
        source = ./config;
        recursive = true;
      };
      "nvim/snippets" = {
        source = rustSnippets;
      };
    };

    dataFile = {
      "nvim/treesitter-parsers" = {
        source = treesitter-parsers;
      };
    };
  };

  home = {
    sessionVariables.EDITOR = "nvim";
    custom.allowed-unfree-packages = [pkgs.codeium];
    packages = with pkgs; [
      tree-sitter
      fswatch

      # formatters
      asmfmt
      ruff
      nasmfmt
      alejandra
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

      # used by codecompanion
      # vectorcode
      # inputs.mcp-hub.default

      # LSP servers
      asm-lsp
      clang-tools
      codeium
      dockerfile-language-server-nodejs
      gopls
      ltex-ls-plus
      python312Packages.pylatexenc
      lua-language-server
      nil
      nodePackages.typescript-language-server
      pyright
      rust-analyzer
      taplo
      terraform-ls
      yaml-language-server
      vscode-langservers-extracted
      zls

      # debug
      delve
      gdb
      codelldb
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
