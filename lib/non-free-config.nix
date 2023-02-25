{ ... }@inputs:
pkg:
builtins.elem (inputs.nixpkgs.lib.getName pkg) [
  "dropbox"
  "grammarly"
  "lastpass-password-manager"
  "skypeforlinux"
  "slack"
  "zoom"
]
