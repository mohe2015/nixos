{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/monitoring/grafana.nix
  services.grafana = {
    enable = true;
    database = {
      type = "postgres";
    };
  };
}
