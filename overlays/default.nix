{ outputs, inputs }:
{

  additions = final: prev: import ../pkgs { pkgs = final; };

  neovim = inputs.neovim-nightly.overlay;
}
