{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nix = {
    package = pkgs.nixUnstable;

    settings.sandbox = true;
    settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.mutableUsers = true; # guix
}
