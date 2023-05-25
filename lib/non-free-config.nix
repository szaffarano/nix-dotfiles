{ ... }@inputs:
pkg:
builtins.elem (inputs.nixpkgs.lib.getName pkg) [
  "datagrip"
  "dropbox"
  "grammarly"
  "okta-browser-plugin"
  "skypeforlinux"
  "slack"
  "vscode"
  "zoom"
]
