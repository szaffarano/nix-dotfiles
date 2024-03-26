{ ... }@inputs:
pkg:
builtins.elem (inputs.nixpkgs.lib.getName pkg) [
  "datagrip"
  "dropbox"
  "grammarly"
  "idea-ultimate"
  "okta-browser-plugin"
  "skypeforlinux"
  "slack"
  "vault-bin"
  "vscode"
  "zoom"
]
