{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.cli.gcp;
in
with lib;
{
  options.terminal.cli.gcp.enable = mkEnableOption "gcp";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.pubsub-emulator
        google-cloud-sdk.components.cloud-firestore-emulator
      ])
    ];
  };
}
