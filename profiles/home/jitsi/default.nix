{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/jitsi-meet.nix
  services.jitsi-meet = {
    enable = true;
    hostName = "meet.pi.example.org";
  };

}
