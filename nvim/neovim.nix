{lib, pkgs}:
{
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    #extraConfig = lib.fileContents ./init.lua;
    extraConfig = builtins.concatStringsSep "\n" [
      ''
      :lua require('init')                                                 
      ''                                                                   
    ];
}
