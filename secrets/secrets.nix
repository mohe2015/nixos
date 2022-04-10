let
  nixos_moritz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4";
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENrl0/XdzqHB9adFkmAAg/ArDWvubhQPe8DwxxlqWDe";

  # ssh root@192.168.100.11 # kick of host key generation as this is socket activated
  nixsd = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGLfiYkTFKk/kWOfbFQ6/03tgBQOc0A7sy+c2YuLo0D"; # sudo cat /var/lib/containers/pi/etc/ssh/ssh_host_ed25519_key.pub
in
{
  "eduroam.age".publicKeys = [ nixos_moritz nixos ];
}
