{ pkgs, ... }:
{
  home-manager.users.tu = {
    imports = [ ];

    home.packages = with pkgs; [
      pkgs.firefox
      pkgs.chromium
      pkgs.keepassxc
      pkgs.zoom-us
      pkgs.git
    ];
  };
  
  users.users.tu = {
    hashedPassword = "$6$KycoTiPm3n.Mayc$7ZDSUvfXEP7zsyDGslx/C5HIbM.fZlfbK0ppsRHSbVNb6O8AqSbF1sjUsSkzEthDneean2fYtEQm.KGZYNbS.1";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
