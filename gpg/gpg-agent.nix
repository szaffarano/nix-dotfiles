{}:
{
    enable = true;
    enableSshSupport = true;

    defaultCacheTtl = 28800;
    defaultCacheTtlSsh = 28800;
    maxCacheTtl = 43200;
    maxCacheTtlSsh = 43200;

    extraConfig = ''
      ttyname $GPG_TTY
    '';
}
