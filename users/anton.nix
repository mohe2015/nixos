{ pkgs, ... }:
{
  home-manager.users.anton = {
    home.packages = with pkgs; [

      (pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [ ms-vscode.cpptools ]; # jnoortheen.nix-ide mshr-h.veriloghdl ];
      })
    ];
  };


  users.users.anton = {
    password = "anton";
    isNormalUser = true;
    extraGroups = [ ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
