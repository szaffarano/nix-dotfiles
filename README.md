# Nix Based dotfiles

## Preconditions

### Bootstrap nix and home-manager

```sh
# TODO: Ubuntu
sudo pacman -S --needed git base-devel

sh <(curl -L https://nixos.org/nix/install) --daemon

mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" \
        | tee ~/.config/nix/nix.conf

nix build --no-link .#homeConfigurations.$USER@host.activationPackage

"$(nix path-info .#homeConfigurations.$USER@host.activationPackage)"/activate
or
./result/activate

# after above command, to update

home-manager switch --flake .#$USER
```

### System-level setup

Only meant to be used for non-nixos Linux environments

```sh
export LC_ALL=C.UTF-8
cd ansible
ansible-galaxy install -r requirements.yml --timeout 120
ansible-playbook linux.yml -K -l dell.local
```

## TODO

- [ ] Automate the bootstrap process
- [ ] Include scripts and static configs not covered by home-manager
- [ ] Review old programs and configs to migrate to home-manager
- [X] Add flakes for other environments
- [ ] Archlinux support
- [ ] Darwin support
- [ ] Ubuntu support
- [ ] FreeBSD support
