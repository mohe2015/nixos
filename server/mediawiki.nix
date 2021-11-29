{ config, lib, pkgs, ... }:
{
  age.secrets.mediawiki_admin.file = ./secrets/mediawiki_admin.age;
  age.secrets.mediawiki_admin.owner = "mediawiki";

  services.httpd.adminAddr = "Moritz.Hedtke@t-online.de";

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/mediawiki.nix
  services.mediawiki = {
    enable = true;
    virtualHost = {
      hostName = "wiki.selfmade4u.de";
      listen = [{ ip = "*"; port = 8081; }];
    };
    database = {
      type = "mysql";
      createLocally = true;
    };
    # username = admin
    # tr -dc A-Za-z0-9 < /dev/urandom | head -c 64
    passwordFile = config.age.secrets.mediawiki_admin.path; # must be at least 10 chars
    extraConfig = ''
      $wgShowExceptionDetails = true;
    '';
  };

  services.nginx = {
    virtualHosts = {
      "nginx-wiki.selfmade4u.de" = {
        serverName = "wiki.selfmade4u.de";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8081";
        };
      };
    };
  };
}
