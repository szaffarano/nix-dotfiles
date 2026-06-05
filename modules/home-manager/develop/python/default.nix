{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.python;
in
  with lib; {
    options.develop.python.enable = mkEnableOption "python";

    config = with pkgs;
      lib.mkIf cfg.enable {
        # workaround to make python's urllib work
        home.sessionVariables = {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        };
        home = {
          packages = [
            uv
          ];
        };
      };
  }
