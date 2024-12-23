# NixOS livesystem to generate yubikeys in an air-gapped manner
# screenshot: https://dl.thalheim.io/ZF5Y0yyVRZ_2MWqX2J42Gg/2020-08-12_16-00.png
# $ nixos-generate -f iso -c yubikey-image.nix
#
# to test it in a vm:
#
# $ nixos-generate --run -f vm -c yubikey-image.nix
{ pkgs, lib, ... }:
let
  mount-volumes =
    (pkgs.writeShellApplication {
      name = "mount-volumes";
      runtimeInputs = [ pkgs.coreutils ];
      text = builtins.readFile ./scripts/mount-volumes.sh;
    })
    // {
      meta = with lib; {
        licenses = licenses.mit;
        mainProgram = "mount-volumes";
        platforms = platforms.all;
      };
    };
  sync-gnupghome =
    (pkgs.writeShellApplication {
      name = "sync-gnupghome";
      runtimeInputs = [ pkgs.coreutils ];
      text = builtins.readFile ./scripts/sync-gnupghome.sh;
    })
    // {
      meta = with lib; {
        licenses = licenses.mit;
        mainProgram = "sync-gnupghome";
        platforms = platforms.all;
      };
    };
  update-expiration =
    (pkgs.writeShellApplication {
      name = "update-expiration";
      runtimeInputs = [ pkgs.coreutils ];
      text = builtins.readFile ./scripts/update-expiration.sh;
    })
    // {
      meta = with lib; {
        licenses = licenses.mit;
        mainProgram = "update-expiration";
        platforms = platforms.all;
      };
    };

  backup-gnupghome =
    (pkgs.writeShellApplication {
      name = "backup-gnupghome";
      runtimeInputs = [ pkgs.coreutils ];
      text = builtins.readFile ./scripts/backup-gnupghome.sh;
    })
    // {
      meta = with lib; {
        licenses = licenses.mit;
        mainProgram = "backup-gnupghome";
        platforms = platforms.all;
      };
    };

  guide = pkgs.stdenv.mkDerivation {
    name = "yubikey-guide-2024-12-09.html";
    src = pkgs.fetchFromGitHub {
      owner = "drduh";
      repo = "YubiKey-Guide";
      rev = "166f838a437304872b12a38ad6f1066b7a2e65e5";
      sha256 = "sha256-5njR8Ha2FvELuRtcEKoQuQ8BKqSiZHDA3RJGYrPRDfg=";
    };
    buildInputs = [ pkgs.pandoc ];
    installPhase = ''
      pandoc --highlight-style pygments -s --toc README.md | \
        sed -e 's/<keyid>/\&lt;keyid\&gt;/g' > $out
    '';
  };
in
{
  environment.interactiveShellInit = ''
    export GNUPGHOME=/run/user/$(id -u)/gnupghome
    export YUBIKEY_GUIDE=${guide}

    [ -d $GNUPGHOME ] || mkdir $GNUPGHOME

    chmod 700 $GNUPGHOME

    [ -f "$GNUPGHOME/gpg.conf" ] || cp ${
      pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/drduh/config/eedb4ecf4bb2b5fd71bb27768f76da0f2e2605c8/gpg.conf";
        sha256 = "sha256-jMo0AGa3lXlLAjCi61LvyW9WvJxJBVlRV9p1yIRv1lo=";
      }
    } "$GNUPGHOME/gpg.conf"

    echo "\$GNUPGHOME has been set up for you. Generated keys will be in $GNUPGHOME."
    echo "Helper scripts: \
      ${mount-volumes.meta.mainProgram}, \
      ${sync-gnupghome.meta.mainProgram}, \
      ${update-expiration.meta.mainProgram}, \
      ${backup-gnupghome.meta.mainProgram}"
    echo "Read the YubiKey Guide (env var \$YUBIKEY_GUIDE): ${guide}"
  '';

  environment.systemPackages = with pkgs; [
    age
    backup-gnupghome
    cryptsetup
    ctmg
    gnupg
    mount-volumes
    neovim.unwrapped
    paperkey
    pinentry-curses
    pwgen
    sync-gnupghome
    update-expiration
    yubikey-personalization
  ];

  services.udev.packages = with pkgs; [ yubikey-personalization ];
  services.pcscd.enable = true;

  # make sure we are air-gapped
  networking.wireless.enable = false;
  networking.dhcpcd.enable = false;

  services.getty.helpLine = "The 'root' account has an empty password.";

  security.sudo.wheelNeedsPassword = false;
  users.users.yubikey = {
    isNormalUser = true;
    initialPassword = "yubikey";
    extraGroups = [ "wheel" ];
    shell = "/run/current-system/sw/bin/bash";
  };

  system.stateVersion = "25.05";
}
