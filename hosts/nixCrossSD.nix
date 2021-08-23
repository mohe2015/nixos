{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64-new-kernel.nix"
  ];

  nixpkgs = {
    crossSystem = lib.systems.examples.aarch64-multiplatform;
    localSystem = { system = "x86_64-linux"; };
  };
}
