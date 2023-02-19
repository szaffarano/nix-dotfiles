_:
{ config, lib, pkgs, ... }:

{
  options.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      package = with pkgs; firefox-wayland;
      profiles.sebas = {
        id = 0;
        isDefault = true;

        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          grammarly
          keepassxc-browser
          facebook-container
          lastpass-password-manager
        ];

        settings = {
          "browser.newtabpage.enabled" = false;
          "browser.startup.page" = 3;
          "browser.startup.homepage" = "about:blank";
          "full-screen-api.ignore-widgets" = true;
          "privacy.webrtc.legacyGlobalIndicator" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_pbm" = true;
        };
      };
    };

    home.sessionVariables = { MOZ_ENABLE_WAYLAND = 1; };
  };
}
