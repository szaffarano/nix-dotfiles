# Nix Based dotfiles

## Preconditions

### Bootstrap nix and home-manager

```sh
# only for archlinux, needed to build AUR packages
sudo pacman -S --needed git base-devel

sh <(curl -L https://nixos.org/nix/install) --daemon

mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" \
        | tee ~/.config/nix/nix.conf

# for linux
nix build .#homeConfigurations.USER@host.activationPackage \
        && ./result/activate

# for Darwin

nix build .#darwinConfigurations.szaffarano@macbook.system \
    && printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf \
    && /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t \
    && darwin-rebuild switch --flake .#USER@macbook
```

### System-level setup

Only meant to be used for non-nixos Linux environments

```sh
export LC_ALL=C.UTF-8
cd ansible
ansible-galaxy install -r requirements.yml --timeout 120
ansible-playbook linux.yml -K -l dell.local
```

### Update

```sh
# for linux
home-manager switch --flake .#$USER

# for darwin
darwin-rebuild switch --flake .
```

## TODO

### Tasks

- [ ] Automate the bootstrap process
- [X] Add flakes for other environments
- [X] Bluetooth
- [X] CopyQ config
- [-] Syncthing config (only for linux systems)
- [X] KeepassXC config
- [X] git-credentials-keepass config
- [ ] Add custom scripts to PATH

### OS Integrations

- [X] Archlinux support
- [X] Darwin support
- [X] Ubuntu support
- [ ] FreeBSD support
