{ ... }@inputs:
pkg:
builtins.elem (inputs.nixpkgs.lib.getName pkg) [
  "datagrip"
  "dropbox"
  "grammarly"
  "obsidian"
  "skypeforlinux"
  "slack"
  "zoom"
]
