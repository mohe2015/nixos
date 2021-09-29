{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/teamspeak3.nix
  # try to use matrix instead but this is also available, jitsi-meet is also available
  services.teamspeak3 = {
    #enable = true; # unfree bruh
  };
}
