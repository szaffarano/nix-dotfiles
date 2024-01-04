{ inputs, ... }: {
  disko = inputs.disko.nixosModules.disko;

  desktop = import ./desktop;
  global = import ./global;
}
