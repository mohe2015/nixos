{ config, lib, pkgs, ... }:
{


  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/murmur.nix
  # try to use matrix instead but this is also available, jitsi-meet is also available
  services.murmur = {
    enable = true;
    bonjour = true;
    sslCert = "${config.security.acme.certs."voice.pi.example.org".directory}/fullchain.pem";
    sslKey = "${config.security.acme.certs."voice.pi.example.org".directory}/key.pem";
    # username: SuperUser
    # journalctl -u murmur.service | grep Password
  };

  systemd.services."murmur.service" = {
    requires = [ "voice.pi.example.org" ];
    after = [ "voice.pi.example.org" ];
  };

  security.acme.certs = {
    "voice.pi.example.org" = {
      group = "murmur";
    };
  };

  networking.firewall.allowedTCPPorts = [ 64738 ];
  networking.firewall.allowedUDPPorts = [ 64738 ];
}
