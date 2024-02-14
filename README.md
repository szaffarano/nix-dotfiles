# NixOS Based dotfiles

[![pre-commit](https://github.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml)

## Bootstrap

### Preconditions

1. Create a keypair for the target machine

        ssh-keygen -t ed25519 -C <some comment> -f ssh_host_ed25519_key
1. Generate an age recipient using the above public key (using the
[ssh-to-age](https://github.com/Mic92/ssh-to-age) tool)

        ssh-to-age  -i ssh_host_ed25519_key.pub -o <machine-name>.age.pub.txt
1. Update the [.sops.yaml](./.sops.yaml) configuration file adding the age
recipient.
1. Generate secrets for this machine using both the root's and your own
recipient.  Example for the OS user:

           # copy the output
            echo "<password>" | mkpasswd -s
            
            # add or edit the secrets.yaml file
            sops system/<machine-name>/secrets.yaml

### New machine configuration

1. Based on an existent configuration, create a new one under
[system](./system), e.g., `./system/<machine-name>/default.nix`. Pay attention
to the [disko](https://github.com/nix-community/disko) configuration file to
avoid any hard-to-recover mistake.
1. Same as above but with home-manager configurations, under [users](./users),
e.g., `./users/<user-name>/<machine-name>.nix`
1. Boot the new machine using
[nixos-anywhere](https://github.com/nix-community/nixos-anywhere).  Eventually
you would need to install rsync, `nix-env -iA nixos.rsync`
1. Run nixos-anywhere including the ssh keys generated as preconditions

        ❯ tree /path/to/ssh/key
        /path/to/ssh/key
        └── etc
            └── ssh_host_ed25519_key
        
        ❯ nix run github:nix-community/nixos-anywhere -- \
            --flake .#<machine-name> \
            --extra-files /path/to/ssh/key root@<new-machine-ip>
1. Once finished, login in the new machine, clone the repo and run home-manager

        ssh <user-name>@<new-machine-ip>
        git clone https://github.com/szaffarano/nix-dotfiles .dotfiles
        cd .dotfiles
        home-manager switch --flake .
