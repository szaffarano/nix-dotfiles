# inspired by https://nixos.wiki/wiki/Sway
{
  pkgs,
  lib,
  writeTextFile,
}:
(writeTextFile {
  name = "configure-gtk";
  destination = "/bin/configure-gtk";
  executable = true;
  text = let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    gsettings = "${pkgs.glib.bin}/bin/gsettings";
  in ''
    if [ "$#" -ne 5 ]; then
      echo "Usage: $0 <theme> <cursor-theme> <icon-theme> <font> <monospace-font>"
      exit 1
    fi

    export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    gnome_schema=org.gnome.desktop.interface

    theme="$1"
    cursor_theme="$2"
    icon_theme="$3"
    font="$4"
    monospace_font="$5"

    echo "Configuring GTK..."
    ${gsettings} set "$gnome_schema" gtk-theme "$theme"
    ${gsettings} set "$gnome_schema" cursor-theme "$cursor_theme"
    ${gsettings} set "$gnome_schema" icon-theme "$icon_theme"
    ${gsettings} set "$gnome_schema" font-name "$font 12"
    ${gsettings} set "$gnome_schema" monospace-font-name "$monospace_font 12"
    echo "Done!"
  '';
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
