{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.web.firefox;
in {
  options.desktop.web.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    home = {
      custom.allowed-unfree-packages = with pkgs.nur.repos.rycee.firefox-addons; [
        grammarly
        okta-browser-plugin
      ];
      packages = with pkgs; [inputs.firefox-nightly.packages.${system}.firefox-nightly-bin];
    };
    programs.firefox = {
      enable = true;
      profiles.sebas = {
        id = 0;
        isDefault = true;

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          auto-tab-discard
          decentraleyes
          duckduckgo-privacy-essentials
          facebook-container
          grammarly
          keepassxc-browser
          okta-browser-plugin
          pkgs.linguee-it
          simple-tab-groups
          simple-translate
          ublock-origin
          vimium
        ];

        settings = {
          "browser.newtabpage.enabled" = false;
          "browser.startup.page" = 3;
          "full-screen-api.ignore-widgets" = true;
          "privacy.webrtc.legacyGlobalIndicator" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_pbm" = true;
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.download.useDownloadDir" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage" = "https://start.duckduckgo.com";
          "browser.uiCustomization.state" = lib.readFile ./firefox-ui-customization.json;
          "identity.fxaccounts.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "signon.rememberSignons" = false;
        };
      };
    };
  };
}
