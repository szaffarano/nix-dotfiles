_:
{ config, lib, pkgs, ... }: {
  options.gpg.enable = lib.mkEnableOption "gpg";

  config = let
    sebasPublicKey = pkgs.fetchurl {
      url =
        "https://keys.openpgp.org/vks/v1/by-fingerprint/9AE57D3DE601A79560DD0F4B14F35C58A2191587";
      sha256 = "sha256-AjutFST4fTkQWpUwRm/ww3+o0MiJxz6LFAzB5rLT9qM=";
    };

  in lib.mkIf config.gpg.enable {
    programs.gpg = {
      enable = true;
      settings = {
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

        default-key = "0x14F35C58A2191587";
        trusted-key = "0x14F35C58A2191587";
        group =
          "keygroup = 0xFF00000000000001 0xFF00000000000002 0x14F35C58A2191587";
      };
      publicKeys = [{ source = sebasPublicKey; }];
    };
  };
}
