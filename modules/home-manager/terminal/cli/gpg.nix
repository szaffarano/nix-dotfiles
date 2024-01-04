{ config, lib, pkgs, ... }:
let cfg = config.gpg;
in with lib; {
  options.gpg = {
    enable = mkEnableOption "gpg";
    default-key = mkOption { type = types.str; };
    trusted-key = mkOption { type = types.str; };
  };

  config =
    let
      sebasPublicKey = pkgs.fetchurl {
        url =
          "https://keys.openpgp.org/vks/v1/by-fingerprint/9AE57D3DE601A79560DD0F4B14F35C58A2191587";
        sha256 = "sha256-H7mz2Cceoadwr4fH5Uo1H3CNcsN21KiW++HtdpDCaSg=";
      };

      sebasAtElasticPublicKey = pkgs.fetchurl {
        url =
          "https://keys.openpgp.org/vks/v1/by-fingerprint/77B7F77E3747F3B4482A7AB4B31A0D3EFDC15D4B";
        sha256 = "sha256-gcejo1Ov15Jj0DUHp3jK6lcTLtKWS6poeTPYpqiPw7Q=";
      };

    in
    mkIf cfg.enable {

      home.sessionVariables = {
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
        GPG_TTY = "$(tty)";
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = "qt";

        defaultCacheTtl = 28800;
        defaultCacheTtlSsh = 28800;
        maxCacheTtl = 43200;
        maxCacheTtlSsh = 43200;

        enableExtraSocket = true;

        extraConfig = ''
          ttyname $GPG_TTY
        '';
      };

      programs.gpg = {
        enable = true;
        settings = {
          keyserver = "hkps://keys.openpgp.org";
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list =
            "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";

          charset = "utf-8";
          fixed-list-mode = true;
          no-comments = true;
          no-emit-version = true;
          no-greeting = true;
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = true;
          require-cross-certification = true;
          no-symkey-cache = true;
          use-agent = true;
          throw-keyids = true;

          default-key = config.gpg.default-key;
          trusted-key = config.gpg.trusted-key;
          group =
            "keygroup = 0xFF00000000000001 0xFF00000000000002 ${config.gpg.trusted-key}";
        };
        publicKeys =
          [{ source = sebasPublicKey; } { source = sebasAtElasticPublicKey; }];
      };
    };
}
