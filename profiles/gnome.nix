{ config, pkgs, ... }:
{
    # https://gvolpe.com/blog/gnome3-on-nixos/
    services = {
        xserver = {
            enable = true;
            layout = "de";
            displayManager.gdm.enable = true;
            displayManager.gdm.wayland = false;
            desktopManager.gnome.enable = true;
        };

        dbus.packages = [ pkgs.gnome3.dconf ];
        udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

        gnome.chrome-gnome-shell.enable = true;
    };
}