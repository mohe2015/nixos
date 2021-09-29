{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/moodle.nix
  # uses httpd
  services.moodle = {
    enable = true;
    virtualHost = {
      hostName = "moodle.pi.example.org";
      listen = [{ ip = "*"; ssl = true; port = 8082; }];
      enableACME = true;
      forceSSL = true;
    };
    database = {
      type = "mysql";
    };
    # username admin
    initialPassword = "WHATTHEFUCK";
  };

  services.nginx = {
    virtualHosts = {
      "nginx-moodle.pi.example.org" = {
        serverName = "moodle.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://localhost:8082";
        };
      };
    };
  };
}
