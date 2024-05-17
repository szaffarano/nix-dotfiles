{ config
, lib
, pkgs
, ...
}:
{
  config = lib.mkIf config.services.greetd.enable {
    services.greetd =
      let
        cmd =
          if config.programs.hyprland.enable then
            (lib.getExe config.programs.hyprland.package)
          else if config.programs.sway.enable then
            (lib.getExe config.programs.sway.package)
          else
            builtins.throw "No supported compositor found to configure greetd";
      in
      {
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${cmd}";
            user = "greeter";
          };
        };
      };
  };
}
