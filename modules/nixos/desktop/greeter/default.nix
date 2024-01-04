{ config, lib, pkgs, ... }:
let cfg = config.nixos.desktop.greeter;

in {
  options.nixos.desktop.greeter.enable = lib.mkEnableOption "greeter";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };
  };
}
