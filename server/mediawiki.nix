{ config, lib, pkgs, ... }:
{
  age.secrets.mediawiki_admin.file = ./secrets/mediawiki_admin.age;
  age.secrets.mediawiki_admin.owner = "mediawiki";

  age.secrets.mediawiki_oauth.file = ./secrets/mediawiki_oauth.age;
  age.secrets.mediawiki_oauth.owner = "mediawiki";

  services.httpd.adminAddr = "Moritz.Hedtke@t-online.de";

  # https://github.com/settings/applications/new
  # https://wiki.selfmade4u.de/index.php/Special:PluggableAuthLogin  

  # tail -f /var/log/mediawiki/debug.log | grep -v DBConnection | grep -v DBQuery | grep -v DeferredUpdates | grep -v MessageCache | grep -v SQLBagOStuff | grep -v DBReplication | grep -v session | grep -v objectcache | grep -v localisation

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/mediawiki.nix
  services.mediawiki = {
    enable = true;
    virtualHost = {
      hostName = "wiki.selfmade4u.de";
      listen = [{ ip = "*"; port = 8081; }];
    };
    database = {
      type = "mysql";
      createLocally = true;
    };
    # username = admin
    # tr -dc A-Za-z0-9 < /dev/urandom | head -c 64
    passwordFile = config.age.secrets.mediawiki_admin.path; # must be at least 10 chars
    extensions = {
      PluggableAuth = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/PluggableAuth-REL1_37-5757eca.tar.gz";
        sha256 = "sha256-igmZ2rzQ4qTm6DPV4uuWDxCnaxi+qg/Jii2oU2MsdNw=";
      };
      WSOAuth = let
  package = (import ./mediawiki/default.nix {
    inherit pkgs;
    inherit (pkgs.stdenv.hostPlatform) system;
    noDev = true; # Disable development dependencies
  });

in package.override rec {
  pname = "WSOAuth";

  src = pkgs.fetchFromGitHub {
    owner = "mohe2015";
    repo = "mediawiki-extensions-WSOAuth";
    rev = "d4f532db1f2a6406279b83e98ed2c5a49b51facd";
    sha256 = "sha256-ZHQW7/UwZE9S3QAXzrDYWRvuYzpaJOd/V+QKBwjSBnw=";
  };

  meta = with lib; {
    description = "OAuth authentication for Mediawiki";
    homepage = "https://github.com/mohe2015/mediawiki-extensions-WSOAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ mohe2015 ];
    platforms = platforms.all;
  };
};
    };
    extraConfig = ''
      $wgShowExceptionDetails = true;

      $wgDebugLogFile = "/var/log/mediawiki/debug.log";

      $wgOAuthAuthProvider = "github";
      $wgOAuthClientId = "0a8472b7e0d16ac5e998";
      $wgOAuthClientSecret = file_get_contents("${config.age.secrets.mediawiki_oauth.path}");
      $wgOAuthRedirectUri = "https://wiki.selfmade4u.de/index.php/Special:PluggableAuthLogin";
    '';
  };

  services.nginx = {
    virtualHosts = {
      "nginx-wiki.selfmade4u.de" = {
        serverName = "wiki.selfmade4u.de";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8081";
        };
      };
    };
  };
}
