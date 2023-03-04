inputs: {
  ansible = import ./ansible inputs;
  bat = import ./bat inputs;
  btop = import ./btop inputs;
  copyq = import ./copyq inputs;
  development = import ./development inputs;
  direnv = import ./direnv inputs;
  firefox = import ./firefox inputs;
  flameshot = import ./flameshot inputs;
  fzf = import ./fzf inputs;
  git = import ./git inputs;
  gpg-agent = import ./gpg-agent inputs;
  gpg = import ./gpg inputs;
  gtk = import ./gtk inputs;
  keepassxc = import ./keepassxc inputs;
  kitty = import ./kitty inputs;
  ncspot = import ./ncspot inputs;
  neovim = import ./neovim inputs;
  starship = import ./starship inputs;
  sway = import ./sway inputs;
  tmux = import ./tmux inputs;
  xdg = import ./xdg inputs;
  zsh = import ./zsh inputs;
  nix-index = inputs.nix-index-database.hmModules.nix-index;
  # sway-notification-center = import ./sway-notification-center inputs;
}
