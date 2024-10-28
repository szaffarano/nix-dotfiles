# NixOS Based dotfiles

[![pre-commit](https://github.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml)

## Bootstrap

### Preconditions

1. Create a ssh keypair for the target machine

        # use a ramfs to not store the key in the disk
        mkdir -p /tmp/pki/ram && sudo mount -t tmpfs -o size=10M tmpfs /tmp/pki/ram
        mkdir -p /tmp/pki/ram/etc/ssh && cd /tmp/pki/ram/etc/ssh
        ssh-keygen -t ed25519 -C <some comment> -f ssh_host_ed25519_key
        ssh-keygen -t rsa -C <some comment> -f ssh_host_rsa_key
1. Generate an age recipient using the above public key (using the
[ssh-to-age](https://github.com/Mic92/ssh-to-age) tool)

        ssh-to-age  -i ssh_host_ed25519_key.pub -o ssh_host_ed25519_key.pub.age
        ssh-to-age -private-key  -i ssh_host_ed25519_key -o ssh_host_ed25519_key.age
1. Update the [.sops.yaml](./.sops.yaml) configuration file adding the age
   recipient.
1. Generate secrets for this machine using both the root and your key
   recipients.  Example for the OS user:

            # copy the following command output
            openssl passwd -6

            # Add or edit the secrets.yaml file
            sops system/<machine-name>/secrets.yaml

### New machine configuration

1. Based on an existent configuration, create a new one under the
   [system](./system), e.g., `./system/<machine-name>/default.nix`. Pay
attention to the [Disko](https://github.com/nix-community/disko) configuration
file to avoid any hard-to-recover mistakes.
1. Same as above but with home-manager configurations, under [users](./users),
   e.g., `./users/<user-name>/<machine-name>.nix`
1. Boot the new machine using
   [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).
Eventually, you would need to install rsync, `nix-env -iA nixos.rsync` in the
target machine.
1. Run nixos-anywhere in the host machine, including the SSH keys generated as
   preconditions.

        tree /tmp/pki/ram
        /tmp/pki/ram
        └── etc
            └── ssh
                ├── ssh_host_ed25519_key
                ├── ssh_host_ed25519_key.age.pub
                └── ssh_host_ed25519_key.pub

        # copy the pub keys as part of the new machine's configuration
        cp /tmp/pki/ram/etc/ssh/*pub ./system/<machine-name>

        nix run github:nix-community/nixos-anywhere -- \
            --flake .#<machine-name> \
            --extra-files /tmp/pki/ram root@<new-machine-ip>
1. Once finished, login in to the new machine, clone the repo and run home-manager

        ssh <user-name>@<new-machine-ip>
        git clone https://github.com/szaffarano/nix-dotfiles .dotfiles
        cd .dotfiles
        home-manager switch --flake .
