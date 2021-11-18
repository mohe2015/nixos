#!/bin/sh
set -ex

# ./hetzner-nix-on-deb.sh -n nix-builder -t ccx52

# ./hetzner-nix-on-deb.sh -n nixos -t cx11

while getopts t:n: opts; do
   case ${opts} in
      t) TYPE=${OPTARG} ;;
      n) NAME=${OPTARG} ;;
   esac
done

date

hcloud context use nixos
hcloud server create --datacenter nbg1-dc3 --image debian-11 --type $TYPE --ssh-key ~/.ssh/id_ed25519.pub --name $NAME

sleep 20

# TODO --user-data-from-file

# https://nixos.org/manual/nix/stable/#sect-single-user-installation
ssh-keygen -R $(hcloud server ip $NAME)
ssh-keyscan $(hcloud server ip $NAME) >> ~/.ssh/known_hosts
hcloud server ssh $NAME 'apt update && apt dist-upgrade -y' #  && reboot
hcloud server ssh $NAME 'adduser --disabled-password --gecos "" moritz'
hcloud server ssh $NAME 'echo '"'"'moritz ALL=(ALL) NOPASSWD: ALL'"'"' | sudo EDITOR="tee -a" visudo'
hcloud server ssh $NAME 'mkdir /home/moritz/.ssh/'
hcloud server ssh $NAME 'cp .ssh/authorized_keys /home/moritz/.ssh/'
hcloud server ssh $NAME 'chown -R moritz:moritz /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 700 /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 600 /home/moritz/.ssh/authorized_keys'

# create volume (don't mount it) (50GB)
#sudo mkfs.ext4 -F /dev/disk/by-id/scsi-0HC_Volume_14477825
#sudo mkdir -m 0755 /nix && sudo chown moritz /nix
#echo "/dev/disk/by-id/scsi-0HC_Volume_14477825 /nix ext4 discard,nofail,defaults 0 0" | sudo tee -a /etc/fstab
#sudo mount -a
#sudo chown moritz /nix

hcloud server ssh -u moritz $NAME 'curl -L https://nixos.org/nix/install | sh -s -- --no-daemon'

#sudo rm /nix/var/nix/profiles/per-user/moritz/channels-1-link
#nix-store --gc

# git clone --depth 1 --branch master https://github.com/NixOS/nixpkgs.git

#sudo nano /etc/systemd/logind.conf
#RuntimeDirectorySize=90%
#sudo reboot

date