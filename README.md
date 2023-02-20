# Nix Based dotfiles

## Preconditions

### Bootstrap nix and home-manager

```sh
# TODO: Ubuntu
sudo pacman -S --needed git base-devel

sh <(curl -L https://nixos.org/nix/install) --daemon

mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" \
        | tee ~/.config/nix/nix.conf

nix build --no-link .#homeConfigurations.$USER.activationPackage

"$(nix path-info .#homeConfigurations.$USER.activationPackage)"/activate
or
./result/activate

# after above command, to update

home-manager switch --flake .#$USER
```

### Wayland and sway

```sh
cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook linux.yml -K
```

## TODO

- [ ] Automate the bootstrap process
- [ ] Include scripts and static configs not covered by home-manager
- [ ] Review old programs and configs to migrate to home-manager
- [X] Add flakes for other environments
