{ ... }@inputs:
pkg:
builtins.elem (inputs.nixpkgs.lib.getName pkg) [
  "datagrip"
  "dropbox"
  "grammarly"
  "obsidian"
  "okta-browser-plugin"
  "skypeforlinux"
  "slack"
  "vscode"
  "zoom"
]
