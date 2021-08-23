{ config, lib, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/monitoring/graphite.nix
  services.graphite = {
    web = {
      enable = true;
    };
  };

}
