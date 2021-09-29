{ config, lib, pkgs, ... }:
{
  services.mattermost = {
    enable = true;
    siteUrl = "http://mattermost.pi.example.org";
    siteName = "MatterPi";
    mutableConfig = true; # allow plugin installations
    /*plugins = [
      (pkgs.fetchurl {
          url = "https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.0.1/github-2.0.1.tar.gz";
          hash = "sha256-ze/6dj7XKDFTVwPiW+ENGDL7mgpVKIq7+X+dLvxSWZs=";
      })
    ];*/
  };

  networking.firewall.allowedTCPPorts = [ 8065 ];
}
