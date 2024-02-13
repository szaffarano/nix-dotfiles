_:
{ config, lib, pkgs, ... }: {
  options.gpg-agent.enable = lib.mkEnableOption "gpg-agent";

  config = lib.mkIf config.gpg-agent.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "qt";

      defaultCacheTtl = 28800;
      defaultCacheTtlSsh = 28800;
      maxCacheTtl = 43200;
      maxCacheTtlSsh = 43200;

      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };
  };
}
