# NixOS Based dotfiles

[![pre-commit](https://GitHub.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/szaffarano/nix-dotfiles/actions/workflows/pre-commit.yml)

## Bootstrap

### Preconditions

1. Boot the target machine from a NixOS live ISO, get it on the network, and
   make it reachable over SSH as `root` (the installer image runs `sshd` by
   default; set a temporary password with `passwd` if you have no key set up
   yet). Note its IP address.

1. Create an ssh keypair for the target machine. **Run this on the machine
   that will orchestrate the install (this repo checkout), not on the
   target/live ISO** — `nixos-anywhere`'s `--extra-files` copies local files
   onto the target during install, so the keys need to exist locally first.

   ```bash
    # use a ramfs to not store the key in the disk
    mkdir -p /tmp/pki/ram && sudo mount -t tmpfs -o size=10M tmpfs /tmp/pki/ram
    mkdir -p /tmp/pki/ram/etc/ssh && cd /tmp/pki/ram/etc/ssh
    ssh-keygen -t ed25519 -C <some comment> -f ssh_host_ed25519_key
    ssh-keygen -t rsa -C <some comment> -f ssh_host_rsa_key
   ```

   Only `mount` needs `sudo` — run `ssh-keygen` as your normal user. If the
   private key files end up `root`-owned anyway (e.g. `nixos-anywhere` fails
   with `tar: ...: Permission denied` while copying extra files), fix
   ownership rather than regenerating the keys — regenerating changes the
   public key, invalidating any age recipient/secrets already derived from
   it:

   ```bash
    sudo chown "$(id -u):$(id -g)" ssh_host_ed25519_key ssh_host_rsa_key
    sudo chmod 600 ssh_host_ed25519_key ssh_host_rsa_key
   ```

   This only affects local readability so `nixos-anywhere` can read and pack
   the files — per its own docs, ownership on the target is always
   normalized to `root` on extraction regardless of local ownership, so this
   is safe.

1. Generate an age recipient using the above public key (using the
   [ssh-to-age](https://github.com/Mic92/ssh-to-age) tool)

   ```bash
    ssh-to-age -i ssh_host_ed25519_key.pub -o ssh_host_ed25519_key.pub.age
    ssh-to-age -private-key -i ssh_host_ed25519_key -o ssh_host_ed25519_key.age
   ```

1. Update the [.sops.yaml](./.sops.yaml) configuration file adding the age
   recipient.

1. Generate secrets for this machine using both the root and your key
   recipients. Example for the OS user:

   ```bash
        # copy the following command output
        openssl passwd -6

        # Add or edit the secrets.yaml file
        sops system/<machine-name>/secrets.yaml
   ```

### New machine configuration

1. Based on an existent configuration, create a new one under the
   [system](./system), e.g., `./system/<machine-name>/default.nix`. Pay
   attention to the [Disko](https://github.com/nix-community/disko) configuration
   file to avoid any hard-to-recover mistakes:
   - Find the real whole-disk identifier from the live ISO — `ls
     /dev/disk/by-id/ | grep -v part` or `lsblk -d -o NAME,SIZE,MODEL,SERIAL` —
     and use that (not a partition UUID) in `disk-config.nix`.
   - `hardware-configuration.nix` should be seeded from the real
     `nixos-generate-config` output on the target (`cat
     /tmp/hardware-configuration.nix`), not copied blindly from another host —
     kernel modules and CPU features vary by machine.
   - Unless a host explicitly sets a `passwordFile`, `disko` will prompt you
     interactively for a LUKS passphrase per encrypted partition during the
     `nixos-anywhere` run below (keep that terminal in the foreground). None
     of these passphrases are stored anywhere in this repo, and each will be
     required again at every subsequent boot — no auto-unlock (TPM2/clevis)
     is configured for any host.
   - Hosts with a separate encrypted swap partition for hibernation (e.g.
     `carbon`) prompt for **two** passphrases at every boot: root, then swap.
     Swap must use ordinary fixed-passphrase encryption, not disko's
     `randomEncryption`, and can't unlock via a keyfile either — hibernation
     resume is detected before any filesystem is mounted, and a keyfile-based
     unlock (wherever the key lives) requires a filesystem to already be
     mounted to read it, which is too late. See
     [this discussion](https://discourse.nixos.org/t/hibernation-with-disk-encryption/22519)
     for background.

1. Same as above but with home-manager configurations, under [users](./users),
   e.g., `./users/<user-name>/<machine-name>.nix`

1. Register the new host in [flake.nix](./flake.nix), adding a
   `nixosConfigurations.<machine-name>` entry pointing at
   `./system/<machine-name>`.

1. Sanity-check before doing anything destructive:

   ```bash
    nix flake check
   ```

1. Boot the new machine using
   [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).
   If needed, install rsync (`nix-env -iA nixos.rsync`) on the target
   machine.

1. Run nixos-anywhere in the host machine, including the SSH keys generated as
   preconditions. This step formats the target's disk(s) — make sure the
   preconditions above (secrets, `.sops.yaml`, disk identifier) are all in
   place first.

   ```bash
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
   ```

1. Once finished, log in to the new machine, clone the repo and run home-manager

   ```bash
    ssh <user-name>@<new-machine-ip>
    git clone https://github.com/szaffarano/nix-dotfiles .dotfiles
    cd .dotfiles
    home-manager switch --flake .
   ```

1. Once you've confirmed the new machine boots and decrypts its secrets
   correctly, unmount the ramfs on the orchestrator — the SSH host private
   keys were only needed during the `nixos-anywhere` run and shouldn't be
   left sitting in memory:

   ```bash
    sudo umount /tmp/pki/ram
    sudo rmdir /tmp/pki/ram
   ```
