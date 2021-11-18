{ config, lib, pkgs, nixpkgs, ... }:

# WP_VERSION=5.8 WORKERS=1 wp4nix -t tt1-blocks -p gutenberg,wordpress-seo
let wp4nixPackages = pkgs.callPackage "${nixpkgs}/pkgs/servers/web-apps/wordpress/themes-and-plugins" {
  plugins = lib.importJSON ../../../wordpress/plugins.json;
  themes = lib.importJSON ../../../wordpress/themes.json;
  languages = lib.importJSON ../../../wordpress/languages.json;
  pluginLanguages = lib.importJSON ../../../wordpress/pluginLanguages.json;
  themeLanguages = lib.importJSON ../../../wordpress/themeLanguages.json;
};
in
{
  services.httpd.adminAddr = "root@localhost";

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/wordpress.nix
  services.wordpress.sites = {
    "blog.pi.example.org" = {
      #package = pkgs.wordpress.override { wpPlugins = [ wp4nixPackages.plugins.gutenberg ]; wpThemes = [ pkgs.wordpressPackages.themes.twentytwentyone wp4nixPackages.themes.tt1-blocks ]; };
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
