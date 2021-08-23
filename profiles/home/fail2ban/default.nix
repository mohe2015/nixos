{ config, lib, pkgs, ... }:
{

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/security/fail2ban.nix
  services.fail2ban = {
    enable = true;
  };


}
