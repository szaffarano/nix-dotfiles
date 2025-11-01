{
  lib,
  config,
  pkgs,
  ...
}: let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    name = lib.mkOption {
      type = lib.types.str;
      description = "Name for ${kind} font profile";
    };
    size = lib.mkOption {
      type = lib.types.str;
      description = "Size for ${kind} font profile";
    };
    sizeAsInt = lib.mkOption {
      type = lib.types.int;
      description = "Size for ${kind} font profile as integer";
      readOnly = true;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
  };
  cfg = config.fontProfiles;
in {
  options.fontProfiles = {
    enable = lib.mkEnableOption "Whether to enable font profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
    serif = mkFontOption "serif";
    emoji = mkFontOption "emoji";
  };

  config = {
    fonts.fontconfig.enable = lib.mkForce cfg.enable;
    home.packages = lib.optionals cfg.enable [
      cfg.monospace.package
      cfg.regular.package
    ];
    lib.fontProfiles.pxToInt = v: lib.toInt (builtins.replaceStrings ["px"] [""] v);
    fontProfiles = {
      monospace = lib.mkDefault rec {
        family = "sans-serif";
        name = "FiraCode Nerd Font";
        size = "11px";
        sizeAsInt = config.lib.fontProfiles.pxToInt size;
        package = pkgs.nerd-fonts.fira-code;
      };
      regular = lib.mkDefault rec {
        family = "noto-sans";
        name = "Noto Sans";
        size = "10px";
        sizeAsInt = config.lib.fontProfiles.pxToInt size;
        package = pkgs.noto-fonts;
      };
      serif = lib.mkDefault rec {
        family = "noto-serif";
        name = "Noto Serif";
        size = "10px";
        sizeAsInt = config.lib.fontProfiles.pxToInt size;
        package = pkgs.noto-fonts;
      };
      emoji = lib.mkDefault rec {
        family = "Noto";
        name = "Noto Color Emoji";
        size = "10px";
        sizeAsInt = config.lib.fontProfiles.pxToInt size;
        package = pkgs.noto-fonts-color-emoji;
      };
    };
  };
}
