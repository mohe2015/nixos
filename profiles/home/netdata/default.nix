{ config, lib, pkgs, ... }:
{
  # TODO add more collectors and alarms
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/monitoring/netdata.nix
  services.netdata = {
    enable = true;
    config = {
      web = {
        "default port" = 19999;
      };
    };
  };

  services.nginx = {
    virtualHosts = {
      "status.pi.example.org" = {
        serverName = "status.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:19999";
        };
      };
    };
  };
}
