let
  nixos_moritz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4";
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENrl0/XdzqHB9adFkmAAg/ArDWvubhQPe8DwxxlqWDe";
  nixsd = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKFYSUHQGRTugP7V6YC2z2aagATdd1dXwkbbMhN1GQv";
in
{
  "pi-smallstep-intermediate-password.age".publicKeys = [ nixos_moritz nixos nixsd ];
}