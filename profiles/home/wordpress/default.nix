{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/wordpress.nix
  services.wordpress = {
    "blog.pi.example.org" = {
#      package = pkgs.wordpress-core;
#      mutableWpContent = true;
      virtualHost = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  #services.nginx = {
  #  virtualHosts = {
   #   "blog.pi.example.org" = {
 #       serverName = "blog.pi.example.org";
       # forceSSL = true;
        #enableACME = true;
  #      locations."/" = {
  #        proxyPass = "http://localhost:8080";
  #      };
  #    };
  #  };
  #};
}
