{
  inputs.wp4nix.url = "git+file:///etc/nixos/wp4nix";
  inputs.wp4nix.inputs.nixpkgs.follows = "nixpkgs";
  
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs.url = "git+file:///etc/nixos/nixpkgs"; # ?ref=wordpress-improvements-with-phpmyadmin";
  inputs.flake-utils.url = "github:numtide/flake-utils";
    
# nix-shell -p wp-cli --command 'sudo -u wordpress -- wp search-replace "beta.selfmade4u.de" "rc.selfmade4u.de"'

    
  outputs = { self, nixpkgs, flake-utils, wp4nix }:
    #flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages."x86_64-linux";
          wordpressPackages = wp4nix.legacyPackages."x86_64-linux";
      in {
      nixopsConfigurations.default = {

        nixpkgs = nixpkgs;
       
        network.description = "selfmade4u.de";
        network.enableRollback = true;

        # /var/lib/wordpress/beta.selfmade4u.de/
        
        "development.selfmade4u.de" = {
          deployment.targetEnv = "none";
          deployment.targetHost = "168.119.126.133";
          #deployment.targetDomains = ["cloud.selfmade4u.de"];

          imports =
            [
              ./selfmade4u.de/configuration.nix # config from source info because of disk uuids etc.
            ];
        
          systemd.coredump.enable = true;
            
          services.httpd.enable = true;
          services.httpd.adminAddr = "Moritz.Hedtke@t-online.de";

          security.acme.acceptTerms = true;
          security.acme.email = "Moritz.Hedtke@t-online.de";

          networking.firewall.allowedTCPPorts = [ 80 443 ];
          networking.hostName = "development-selfmade4u";
        
          services.phpmyadmin."db.development.selfmade4u.de" = {
            virtualHost = {
              forceSSL = true;
              enableACME = true;
            };
          };
        
          services.wordpress."sv.development.selfmade4u.de" = {
            mutableWpContent = true;
            virtualHost = {
              hostName = "sv.development.selfmade4u.de";
              adminAddr = "Moritz.Hedtke@t-online.de";
              forceSSL = true;
              enableACME = true;
             #serverAliases = [ "selfmade4u.de" "www.selfmade4u.de" ];
            };
            database.name = "wordpress-sv.development.selfmade4u.de";
            database.socket = "/run/mysqld/mysqld.sock";
            package = pkgs.wordpress-core;
            themes = [ wordpressPackages.themes.twentytwenty ];
            plugins = [ wordpressPackages.plugins.gutenberg ];
          };
          
          services.wordpress."beta.development.selfmade4u.de" = {
            virtualHost = {
              hostName = "beta.development.selfmade4u.de";
              adminAddr = "Moritz.Hedtke@t-online.de";
              forceSSL = true;
              enableACME = true;
              #serverAliases = [ "selfmade4u.de" "www.selfmade4u.de" ];
            };
            database.name = "wordpress-beta.development.selfmade4u.de";
            database.socket = "/run/mysqld/mysqld.sock";
            package = pkgs.wordpress-core;
            themes = [ wordpressPackages.themes.twentytwenty ];
            plugins = [
              wordpressPackages.plugins.akismet
              wordpressPackages.plugins.contact-form-7
              wordpressPackages.plugins.flamingo
              wordpressPackages.plugins.gutenberg
              wordpressPackages.plugins.visualizer
              wordpressPackages.plugins.wp-mail-smtp
              wordpressPackages.plugins.shortcodes-ultimate
              wordpressPackages.plugins.health-check
              wordpressPackages.plugins.customizer-export-import
              wordpressPackages.plugins.wordpress-importer
            ];
          };
          
          #system.stateVersion = pkgs.lib.mkForce "20.09";
        };

        "selfmade4u.de" = {
          deployment.targetEnv = "none";
          deployment.targetHost = "78.47.174.150";
          #deployment.targetDomains = ["cloud.selfmade4u.de"];

          imports =
            [
              ./selfmade4u.de/configuration.nix # config from source info because of disk uuids etc.
            ];
            
          systemd.coredump.enable = true;
            
          services.httpd.enable = true;
          services.httpd.adminAddr = "Moritz.Hedtke@t-online.de";

          security.acme.acceptTerms = true;
          security.acme.email = "Moritz.Hedtke@t-online.de";

          networking.firewall.allowedTCPPorts = [ 80 443 ];
          networking.hostName = "selfmade4u";
          
          services.phpmyadmin."db.selfmade4u.de" = {
            virtualHost = {
              forceSSL = true;
              enableACME = true;
            };
          };

          # uses nginx, not working with default configuration
          #services.nextcloud = {
          #  enable = true;
          #  hostName = "cloud.selfmade4u.de";
          #  https = true;
          #  webfinger = true;
          #  config = {
          #      adminpassFile = "secrets/nextcloud-root";
          #      dbtype = "mysql";
          #      dbhost = "/run/mysqld/mysqld.sock";
          #  };
          #  autoUpdateApps.enable = true;
          #};
          
          # https://progressus.io/switching-woocommerce-multisite-single-site/
          # https://deliciousbrains.com/wp-migrate-db-pro/doc/extracting-a-subsite-from-multisite-to-create-a-new-single-site-install/
          # tool https://helgeklein.com/blog/2019/04/migrating-wordpress-from-multisite-to-single-with-mu-migration/
          
          # apex
          # atomic blocks
          # colibri wp
          # masonic
          # ocean wp
          # storefront
          # twenty nineteen
          # twenty twenty
          # twenty twenty blocks

          services.wordpress."beta.selfmade4u.de" = {
            virtualHost = {
              hostName = "rc.selfmade4u.de";
              adminAddr = "Moritz.Hedtke@t-online.de";
              forceSSL = true;
              enableACME = true;
              #serverAliases = [ "selfmade4u.de" "www.selfmade4u.de" ];
            };
            database.socket = "/run/mysqld/mysqld.sock";
            package = pkgs.wordpress-core;
            themes = [ wordpressPackages.themes.oceanwp ];
            plugins = [
              wordpressPackages.plugins.akismet
              wordpressPackages.plugins.contact-form-7
              wordpressPackages.plugins.flamingo
              wordpressPackages.plugins.gutenberg
              wordpressPackages.plugins.visualizer
              wordpressPackages.plugins.wp-mail-smtp
              wordpressPackages.plugins.shortcodes-ultimate
              wordpressPackages.plugins.health-check
              wordpressPackages.plugins.w3-total-cache
              #wordpressPackages.plugins.wp-super-cache
              wordpressPackages.plugins.customizer-export-import
              wordpressPackages.plugins.wordpress-importer
            ];
            extraConfig = ''
            /** Enable W3 Total Cache */
            define('WP_CACHE', true); // Added by W3 Total Cache

            '';
          };

          services.wordpress."sv.selfmade4u.de" = {
            virtualHost = {
              hostName = "sv.selfmade4u.de";
              adminAddr = "Moritz.Hedtke@t-online.de";
              forceSSL = true;
              enableACME = true;
              #serverAliases = [ "selfmade4u.de" "www.selfmade4u.de" ];
            };
            database.socket = "/run/mysqld/mysqld.sock";
            package = pkgs.wordpress-core;
            mutableWpContent = true; # neve doesn't work otherwise
            themes = [ wordpressPackages.themes.neve ];
            plugins = [ wordpressPackages.plugins.gutenberg
            wordpressPackages.plugins.templates-patterns-collection ];
          };
        };
      };
    };
}
