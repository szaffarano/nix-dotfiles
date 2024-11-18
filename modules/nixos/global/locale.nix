{ lib, ... }:
{
  config = {
    i18n = {
      defaultLocale = lib.mkDefault "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = lib.mkDefault "es_AR.UTF-8";
        LC_ALL = lib.mkDefault "en_US.UTF-8";
      };
      supportedLocales = lib.mkDefault [
        "en_US.UTF-8/UTF-8"
        "es_AR.UTF-8/UTF-8"
        "sv_SE.UTF-8/UTF-8"
      ];
    };
    time.timeZone = lib.mkDefault "America/Buenos_Aires";
  };
}
