{ pkgs, ... }:
{

  services.mysql = {
    enable = true;
    ensureUsers = [
      {
        name = "moritz";
        ensurePermissions = {
          "* . *" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "moritz" ];
  };

  services.postgresql = {
    package = pkgs.postgresql_13;
    enable = true;
    ensureUsers = [
      {
        name = "moritz";
        ensurePermissions = {
          "DATABASE moritz" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "moritz" ];
  };
}
