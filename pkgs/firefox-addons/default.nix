{ fetchurl, lib, stdenv }:
let
  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta, ... }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
{

  simple-translate = buildFirefoxXpiAddon {
    pname = "simple-translate";
    version = "2.8.2";
    addonId = "simple-translate@sienori";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4165189/simple_translate-2.8.2.xpi";
    sha256 = "sha256-jow68P+t/T/5koNV574ikr7+bE8OSD98N8LZo0pU80U=";
    meta = with lib; {
      homepage = "https://simple-translate.sienori.com/";
      description =
        "Quickly translate selected text on web page. In toolbar popup, you can translate input text.";
      license = licenses.mpl20;
      mozPermissions = [ "<all_urls>" "storage" "contextMenus" ];
      platforms = platforms.all;
    };
  };

  linguee-it = buildFirefoxXpiAddon {
    pname = "linguee-it";
    version = "0.3.1";
    addonId = "{8a94c7c4-184c-453f-a5d1-3e319062f0a5}";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/541956/linguee_it-0.3.1.xpi";
    sha256 = "sha256-Z72680IjrXznAD1Nf9zPImiH9vvZ8H8zuNPuKXwnGh8=";
    meta = with lib; {
      homepage = "https://github.com/renanbr/linguee-it";
      description = "Displays words and sentences translation using Linguee™";
      license = licenses.mit;
      mozPermissions = [ "activeTab" ];
      platforms = platforms.all;
    };
  };
}
