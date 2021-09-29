{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/monitoring/prometheus/default.nix
  services.prometheus = {
    enable = true;
  };
}
