{ config
, inputs
, lib
, outputs
, pkgs
, ...
}:
{
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };
  # Fix for qt6 plugins
  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
  };

  # environment.enableAllTerminfo = true;
  # TODO: https://github.com/NixOS/nixpkgs/pull/345827
  environment.systemPackages = lib.mkIf config.environment.enableAllTerminfo (
    map (x: x.terminfo) (
      with pkgs.pkgsBuildBuild;
      [
        foot
      ]
    )
  );

}
