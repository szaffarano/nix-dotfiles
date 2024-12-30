{nixpkgs, ...}: let
  toHyprconf = with nixpkgs.lib;
    attrs: indentLevel: let
      indent = concatStrings (replicate indentLevel "  ");

      sections = filterAttrs (n: v: (isAttrs v || hasComplexElements v) && n != "device") attrs;

      mkSection = n: attrs:
        if !(hasComplexElements attrs)
        then ''
          ${indent}${n} {
          ${toHyprconf attrs (indentLevel + 1)}${indent}}
        ''
        else concatStringsSep "\n" (lists.map (nested: mkSection n nested) attrs);

      mkDeviceCategory = device: ''
        ${indent}device {
          name=${device.name}
        ${toHyprconf (filterAttrs (n: _: "name" != n) device) (indentLevel + 1)}${indent}}
      '';

      deviceCategory = optionalString (hasAttr "device" attrs) (
        if isList attrs.device
        then (concatMapStringsSep "\n" mkDeviceCategory attrs.device)
        else mkDeviceCategory attrs.device
      );

      mkFields = generators.toKeyValue {
        listsAsDuplicateKeys = true;
        inherit indent;
      };
      allFields = filterAttrs (n: v: !(isAttrs v) && n != "device" && !(hasComplexElements v)) attrs;

      importantFields =
        filterAttrs (
          n: _: (hasPrefix "$" n) || (hasPrefix "bezier" n) || (hasPrefix "source" n)
        )
        allFields;

      fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);

      hasComplexElements = a: isList a && all isAttrs a;
    in
      mkFields importantFields
      + deviceCategory
      + concatStringsSep "\n" (mapAttrsToList mkSection sections)
      + mkFields fields;
in
  toHyprconf
