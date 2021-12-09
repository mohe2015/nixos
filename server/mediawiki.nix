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
      VisualEditor = null;
      WikiEditor = null;
      TemplateData = null;
      SyntaxHighlight_GeSHi = null;
      CiteThisPage = null;
      MultimediaViewer = null;
      Cite = null;
      CategoryTree = null;
      PluggableAuth = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/PluggableAuth-REL1_37-5757eca.tar.gz";
        sha256 = "sha256-igmZ2rzQ4qTm6DPV4uuWDxCnaxi+qg/Jii2oU2MsdNw=";
      };
      CodeMirror = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_37-6a64183.tar.gz";
        sha256 = "sha256-gmLt2GAzmuo6sJuVAD9NRVHfQGSadHgB5+n6JJs5/uA=";
      };

      MW-OAuth2Client = /etc/nixos/server/MW-OAuth2Client;
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

          src = /*pkgs.fetchFromGitHub {
            owner = "mohe2015";
            repo = "mediawiki-extensions-WSOAuth";
            rev = "e74c2ef2e18de680c37ed6189257fe519ea2efa3";
            sha256 = "sha256-6+1FbIzAUyMcw9gGlccdRUGHdJRsdP1F4DqtdDeKawE=";
            }; */ /etc/nixos/server/mediawiki-extensions-WSOAuth;

          meta = with lib; {
            description = "OAuth authentication for Mediawiki";
            homepage = "https://github.com/mohe2015/mediawiki-extensions-WSOAuth";
            license = licenses.mit;
            maintainers = with maintainers; [ mohe2015 ];
            platforms = platforms.all;
          };
        };
    };
    # TODO FIXME don't allow anonymous edits
    # TODO FIXME don't allow account creation?
    extraConfig = ''
      $wgShowExceptionDetails = true;

      $wgDebugLogFile = "/var/log/mediawiki/debug.log";

      $wgServer = "https://wiki.selfmade4u.de";

      $wgGroupPermissions['*']['autocreateaccount'] = true;

      $wgPluggableAuth_EnableLocalLogin = true;

      $wgOAuthAuthProvider = "github";
      $wgOAuthUri = "";
      $wgOAuthClientId = "0a8472b7e0d16ac5e998";
      $wgOAuthClientSecret = trim(file_get_contents("${config.age.secrets.mediawiki_oauth.path}"));
      $wgOAuthRedirectUri = "https://wiki.selfmade4u.de/index.php/Special:PluggableAuthLogin";
      $wgPluggableAuth_ButtonLabel = "Login with Github";

      $wgPygmentizePath = "${pkgs.python39Packages.pygments}/bin/pygmentize";

      $wgOAuth2Client['client']['id']     = '0a8472b7e0d16ac5e998'; // The client ID assigned to you by the provider
      $wgOAuth2Client['client']['secret'] = trim(file_get_contents("${config.age.secrets.mediawiki_oauth.path}")); // The client secret assigned to you by the provider

      $wgOAuth2Client['configuration']['authorize_endpoint']     = 'https://github.com/login/oauth/authorize'; // Authorization URL
      $wgOAuth2Client['configuration']['access_token_endpoint']  = 'https://github.com/login/oauth/access_token'; // Token URL
      $wgOAuth2Client['configuration']['api_endpoint']           = 'https://api.github.com/user'; // URL to fetch user JSON
      $wgOAuth2Client['configuration']['redirect_uri']           = 'https://wiki.selfmade4u.de/index.php?title=Special:OAuth2Client/callback'; // URL for OAuth2 server to redirect to

      $wgOAuth2Client['configuration']['username'] = 'login'; // JSON path to username
      $wgOAuth2Client['configuration']['email'] = ""; // JSON path to email

      $wgOAuth2Client['configuration']['scopes'] = 'user:email'; //Permissions
    '';
  };

  services.nginx = {
    virtualHosts = {
      "nginx-wiki.selfmade4u.de" = {
        serverName = "wiki.selfmade4u.de";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8081"; # TODO FIXME get the apache in between removed as this causes just more problems
        };
        extraConfig = ''
          client_max_body_size 100M;
          proxy_connect_timeout       300;
          proxy_send_timeout          300;
          proxy_read_timeout          300;
          send_timeout                300;
        '';
      };
    };
  };

  services.phpfpm.pools.mediawiki.phpOptions = ''
    post_max_size = 100M
    upload_max_filesize = 100M
  '';
}
