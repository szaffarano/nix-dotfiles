{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = let
    rawKeys = builtins.readFile (
      pkgs.fetchurl {
        url = "https://api.github.com/users/szaffarano/gpg_keys";
        hash = "sha256-6drqcf2yREpDGNySzAxIouqdGv3P8HBP7T7NKhb+oM4=";
      }
    );

    gpgKeys = builtins.map (k: {text = k.raw_key;}) (builtins.fromJSON rawKeys);
  in {
    home = mkIf config.programs.gpg.enable {
      sessionVariables = {
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
        GPG_TTY = "$(tty)";
      };

      packages = with pkgs; [pinentry-curses];
    };

    services.gpg-agent = mkIf config.programs.gpg.enable {
      enable = true;
      enableSshSupport = true;
      enableScDaemon = true;
      pinentry.package = pkgs.pinentry-qt;

      defaultCacheTtl = 28800;
      defaultCacheTtlSsh = 28800;
      maxCacheTtl = 43200;
      maxCacheTtlSsh = 43200;

      enableExtraSocket = true;

      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };

    programs.gpg = mkIf config.programs.gpg.enable {
      scdaemonSettings = lib.mkIf osConfig.services.pcscd.enable {disable-ccid = true;};
      settings = {
        keyserver = "hkps://keys.openpgp.org";
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
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
        group = "keygroup = 0xFF00000000000001 0xFF00000000000002";
      };
      publicKeys = gpgKeys;
    };
  };
}
