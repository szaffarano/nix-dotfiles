{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.web.chromium;
in {
  options.desktop.web.chromium.enable = lib.mkEnableOption "chromium";

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
    };
  };
}
