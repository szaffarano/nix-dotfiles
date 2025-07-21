{inputs, ...}: {
  additions = final: _: import ../pkgs {pkgs = final;};

  neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

  cliphist = import ./cliphist;

  rust = inputs.rust-overlay.overlays.default;

  nur = inputs.nur.overlays.default;

  wl-clipboard = import ./wl-clipboard;

  vectorcode = final: prev: {
    vectorcode = prev.vectorcode.overridePythonAttrs (_old: rec {
      version = "0.7.9";
      src = final.fetchFromGitHub {
        owner = "Davidyz";
        repo = "VectorCode";
        tag = version;
        hash = "sha256-EU/JitByOXfquMCcMHH14gCbVl/oHpREAcQNxmOuI+E=";
      };
      pythonRelaxDeps = [
        "posthog"
      ];

      meta = {
        description = "Code repository indexing tool to supercharge your LLM experience";
        homepage = "https://github.com/Davidyz/VectorCode";
        changelog = "https://github.com/Davidyz/VectorCode/releases/tag/${src.tag}";
        mainProgram = "vectorcode";
        badPlatforms = [];
      };
    });
  };

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  #
  # Thanks Misterio77!
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };
}
