{ config, lib, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/searx.nix
  services.searx = {
    enable = true;
    # https://searx.github.io/searx/admin/settings.html
    settings = {
      server.port = 8084;
      server.secret_key = "evenmoresecretkey"; # TODO FIXME
    };
    # TODO FIXME runInUwsgi
  };

  services.nginx = {
    virtualHosts = {
      "nginx-search.pi.example.org" = {
        serverName = "search.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8084";
        };
      };
    };
  };
}
