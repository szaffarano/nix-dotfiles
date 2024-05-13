{ inputs, outputs, ... }:
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

  environment.enableAllTerminfo = true;
}
