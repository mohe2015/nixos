{
  description = "wp4nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        legacyPackages = pkgs.lib.recurseIntoAttrs
            (let
                json = {
                    plugins = builtins.fromJSON (pkgs.lib.readFile ./plugins.json);
                    themes = builtins.fromJSON (pkgs.lib.readFile ./themes.json);
                    languages = builtins.fromJSON (pkgs.lib.readFile ./languages.json);
                    pluginLanguages = builtins.fromJSON (pkgs.lib.readFile ./pluginLanguages.json);
                    themeLanguages = builtins.fromJSON (pkgs.lib.readFile ./themeLanguages.json);
                };
                filterFileName = f: builtins.replaceStrings [ " " "," "/" "&" ";" ''"'' "'" "$" ":" "(" ")" "[" "]" "{" "}" "|" "*" "\t" ] [ "_" "." "." "" "" "" "" "" "" "" "" "" "" "" "" "-" "" "" ] f;
                fetch = t: v: pkgs.fetchsvn {
                inherit (v) rev sha256;
                url = if t == "plugins" || t == "themes" then
                    "https://" + t + ".svn.wordpress.org/" + v.path
                else if t == "languages" then
                    "https://i18n.svn.wordpress.org/core/" + v.version + "/" + v.path
                else if t == "pluginLanguages" then
                    "https://i18n.svn.wordpress.org/plugins/" + v.path
                else if t == "themeLanguages" then
                    "https://i18n.svn.wordpress.org/themes/" + v.path
                else
                    throw "invalid fetch type";
                };
                mkPkg = type: pname: value: pkgs.stdenvNoCC.mkDerivation ({
                inherit pname;
                version = filterFileName value.version;
                src = fetch type value;
                installPhase = ''
                    cp -R ./. $out
                '';
                } // pkgs.lib.optionalAttrs (type == "languages" || type == "pluginLanguages" || type == "themeLanguages") {
                nativeBuildInputs = [ pkgs.gettext pkgs.wp-cli ];
                buildPhase = ''
                    find -name '*.po' -print0 | while IFS= read -d "" -r po; do
                    msgfmt -o $(basename "$po" .po).mo "$po"
                    done
                    wp i18n make-json .
                    rm *.po
                '';
                });
            in
                pkgs.lib.genAttrs [ "plugins" "themes" "languages" "pluginLanguages" "themeLanguages" ] (t: pkgs.lib.recurseIntoAttrs (pkgs.lib.mapAttrs (mkPkg t) json."${t}")));
        packages = flake-utils.lib.flattenTree legacyPackages;
      }
    );
}

