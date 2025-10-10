{
  fetchurl,
  lib,
  stdenv,
}: let
  buildFirefoxXpiAddon = {
    pname,
    version,
    addonId,
    url,
    sha256,
    meta,
    ...
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {inherit url sha256;};

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {
        inherit addonId;
      };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in {
  linguee-it = buildFirefoxXpiAddon {
    pname = "linguee-it";
    version = "0.3.2resigned1";
    addonId = "{8a94c7c4-184c-453f-a5d1-3e319062f0a5}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4271320/linguee_it-0.3.2resigned1.xpi";
    sha256 = "sha256-PxA3y+R24LOWzhvIcllf/r1odjvpi5p/KmO5vlYVAHA=";
    meta = with lib; {
      homepage = "https://github.com/renanbr/linguee-it";
      description = "Displays words and sentences translation using Linguee™";
      license = licenses.mit;
      mozPermissions = ["activeTab"];
      platforms = platforms.all;
    };
  };
}
