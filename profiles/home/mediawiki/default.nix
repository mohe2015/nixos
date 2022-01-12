{ config, lib, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/mediawiki.nix
  services.mediawiki = {
    enable = true;
    virtualHost = {
      hostName = "wiki.pi.example.org";
      listen = [{ ip = "*"; port = 8081; }];
    };
    database = {
      type = "mysql";
      createLocally = true;
    };
    # username = admin
    passwordFile = ../../../secrets/pi-mediawiki-password; # must be at least 10 chars
    extraConfig = ''
      $wgShowExceptionDetails = true;
    '';
  };

  services.nginx = {
    virtualHosts = {
      "nginx-wiki.pi.example.org" = {
        serverName = "wiki.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8081";
        };
      };
    };
  };
}
