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
      WSOAuth =
        let
          package = (import ./mediawiki/default.nix {
            inherit pkgs;
            inherit (pkgs.stdenv.hostPlatform) system;
            noDev = true; # Disable development dependencies
          });

        in
        package.override rec {
          pname = "WSOAuth";

          src = pkgs.fetchFromGitHub {
            owner = "mohe2015";
            repo = "mediawiki-extensions-WSOAuth";
            rev = "e74c2ef2e18de680c37ed6189257fe519ea2efa3";
            sha256 = "sha256-6+1FbIzAUyMcw9gGlccdRUGHdJRsdP1F4DqtdDeKawE=";
          }; # ./mediawiki-extensions-WSOAuth;

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

      $wgGroupPermissions['*']['autocreateaccount'] = true;

      $wgOAuthAuthProvider = "github";
      $wgOAuthUri = "";
      $wgOAuthClientId = "0a8472b7e0d16ac5e998";
      $wgOAuthClientSecret = trim(file_get_contents("${config.age.secrets.mediawiki_oauth.path}"));
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
