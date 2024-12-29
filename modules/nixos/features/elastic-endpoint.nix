{
  config,
  lib,
  ...
}: let
  feature_name = "elastic-endpoint";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    systemd.services = lib.mkIf enabled {
      ElasticEndpoint = {
        wantedBy = ["multi-user.target"];
        description = "ElasticEndpoint";
        unitConfig = {
          StartLimitInterval = 600;
          ConditionFileIsExecutable = "/opt/Elastic/Endpoint/elastic-endpoint";
        };
        serviceConfig = {
          ExecStart = "/opt/Elastic/Endpoint/elastic-endpoint run";
          Restart = "on-failure";
          RestartSec = 15;
          StartLimitBurst = 16;
        };
      };

      elastic-agent = {
        wantedBy = ["multi-user.target"];
        description = "Elastic Agent is a unified agent to observe, monitor and protect your system.";
        unitConfig = {
          StartLimitInterval = 5;
          ConditionFileIsExecutable = "/opt/Elastic/Agent/elastic-agent";
        };
        serviceConfig = {
          ExecStart = "/opt/Elastic/Agent/elastic-agent";
          WorkingDirectory = "/opt/Elastic/Agent";
          Restart = "always";
          RestartSec = 120;
          KillMode = "process";
          StartLimitBurst = 10;
        };
      };
    };

    nixos.custom.features.register = feature_name;
  };
}
