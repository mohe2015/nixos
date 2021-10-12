{ pkgs, ... }:
{

  services.mysql = {
    package = pkgs.mariadb;
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
    package = pkgs.postgresql_14;
    enable = true;
    ensureUsers = [
      {
        name = "moritz";
        ensurePermissions = {
          "DATABASE moritz" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
    ensureDatabases = [ "moritz" ];
  };
}
