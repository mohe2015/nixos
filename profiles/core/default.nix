{ config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
