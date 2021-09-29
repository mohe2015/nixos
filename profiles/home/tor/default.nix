{ config, lib, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/security/tor.nix
  services.tor = {
    enable = true;
    relay.onionServices = { };
  };
}
