{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/system/earlyoom.nix
  services.earlyoom = {
    enable = true;
  };
}
