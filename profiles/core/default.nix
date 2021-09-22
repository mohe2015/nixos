{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  nix = {
    package = pkgs.nixUnstable.override {
      patches = [ ./unset-is-macho.patch ];
    };

    useSandbox = true;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.mutableUsers = false;
}
