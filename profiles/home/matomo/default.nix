{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/matomo.nix
  services.matomo = {
    enable = true;
    nginx = {
      serverName = "analytics.pi.example.org";
    };
  };

  services.mysql = {
    ensureDatabases = [ "matomo" ];
    ensureUsers = [
      {
        name = "matomo";
        ensurePermissions = {
          "matomo.*" = "ALL";
        };
      }
    ];
  };
}
