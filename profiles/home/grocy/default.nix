{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/grocy.nix
  services.grocy = {
    # username: admin, password: admin
    enable = true;
    hostName = "food.pi.example.org";
    nginx.enableSSL = true;
    settings = {
      currency = "EUR";
      culture = "de";
    };
  };
}
