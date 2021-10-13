{ config, lib, pkgs, nixpkgs, ... }:

let wp4nixPackages = pkgs.callPackage "${nixpkgs}/pkgs/servers/web-apps/wordpress/themes-and-plugins" {
  plugins = builtins.fromJSON (builtins.readFile ../../../wordpress/plugins.json);
  themes = builtins.fromJSON (builtins.readFile ../../../wordpress/themes.json);
  languages = builtins.fromJSON (builtins.readFile ../../../wordpress/languages.json);
  pluginLanguages = builtins.fromJSON (builtins.readFile ../../../wordpress/pluginLanguages.json);
  themeLanguages = builtins.fromJSON (builtins.readFile ../../../wordpress/themeLanguages.json);
};
in
{
  services.httpd.adminAddr = "root@localhost";
  
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/wordpress.nix
  services.wordpress.sites = {
    "blog.pi.example.org" = {
      package = pkgs.wordpress.override { wpPlugins = [ wp4nixPackages.plugins.gutenberg ]; wpThemes = [ pkgs.wordpressPackages.themes.twentytwentyone wp4nixPackages.themes.tt1-blocks ]; };
#      mutableWpContent = true;
      #virtualHost = {
      #  forceSSL = true;
      #  enableACME = true;
      #};
    };
  };

  #services.nginx = {
  #  virtualHosts = {
   #   "blog.pi.example.org" = {
 #       serverName = "blog.pi.example.org";
       # forceSSL = true;
        #enableACME = true;
  #      locations."/" = {
  #        proxyPass = "http://localhost:8080";
  #      };
  #    };
  #  };
  #};
}
