{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/misc/gitea.nix
  services.gitea = {
    enable = true;
    database = {
      type = "postgres";
    };
    httpPort = 8085;
    # enableUnixSocket
    # first user is admin, TODO disable registration and create admin user declaratively
  };

  services.nginx = {
    virtualHosts = {
      "nginx-git.pi.example.org" = {
        serverName = "git.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8085";
        };
      };
    };
  };
}
