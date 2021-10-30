set -ex

# TODO FIXME the image currently contains the public key - maybe it can be overwritten using --user-data-from-file. But this is not so important as currently every user has to generate his image himself anyways.

# ./hetzner.sh -n template -t cpx11

while getopts t:n: opts; do
   case ${opts} in
      t) TYPE=${OPTARG} ;;
      n) NAME=${OPTARG} ;;
   esac
done

date

hcloud context use nixos
hcloud server create --datacenter nbg1-dc3 --image debian-11 --type $TYPE --ssh-key ~/.ssh/id_rsa.pub --name $NAME

sleep 20

# TODO --user-data-from-file

# https://nixos.org/manual/nixos/stable/#sec-installing-from-other-distro
ssh-keygen -R $(hcloud server ip $NAME)
ssh-keyscan $(hcloud server ip $NAME) >> ~/.ssh/known_hosts
hcloud server ssh $NAME 'adduser --disabled-password --gecos "" moritz'
hcloud server ssh $NAME 'echo '"'"'moritz ALL=(ALL) NOPASSWD: ALL'"'"' | sudo EDITOR="tee -a" visudo'
hcloud server ssh $NAME 'mkdir /home/moritz/.ssh/'
hcloud server ssh $NAME 'cp .ssh/authorized_keys /home/moritz/.ssh/'
hcloud server ssh $NAME 'chown -R moritz:moritz /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 700 /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 600 /home/moritz/.ssh/authorized_keys'
# create volume (don't mount it) (50GB)
hcloud volume attach volume-nix --server $NAME
hcloud server ssh $NAME 'sudo mkfs.ext4 -F /dev/disk/by-id/scsi-0HC_Volume_14477825' # TODO comment this out
hcloud server ssh $NAME 'sudo mkdir -m 0755 /nix && sudo chown moritz /nix'
hcloud server ssh $NAME 'echo "/dev/disk/by-id/scsi-0HC_Volume_14477825 /nix ext4 discard,nofail,defaults 0 0" | sudo tee -a /etc/fstab'
hcloud server ssh $NAME 'sudo mount -a'
hcloud server ssh $NAME 'sudo chown moritz /nix'
hcloud server ssh -u moritz $NAME 'curl -L https://nixos.org/nix/install | sh'
hcloud server ssh -u moritz $NAME 'echo '"'"'if [ -e /home/moritz/.nix-profile/etc/profile.d/nix.sh ]; then . /home/moritz/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer'"'"' | cat - ~/.bashrc | tee ~/.bashrc'
hcloud server ssh -u moritz $NAME 'nix-channel --add https://nixos.org/channels/nixos-unstable-small nixpkgs'
hcloud server ssh -u moritz $NAME 'nix-channel --update'
hcloud server ssh -u moritz $NAME 'nix-env -f '"'"'<nixpkgs/nixos>'"'"' --arg configuration {} -iA config.system.build.{nixos-generate-config,nixos-install,nixos-enter}'
hcloud server ssh -u moritz $NAME 'sudo `which nixos-generate-config` --root /'

hcloud server ip $NAME
hcloud server ip --ipv6 $NAME

scp configuration.nix root@$(hcloud server ip $NAME):/etc/nixos/configuration.nix

hcloud server ssh -u moritz $NAME 'nix-env -p /nix/var/nix/profiles/system -f '"'"'<nixpkgs/nixos>'"'"' -I nixos-config=/etc/nixos/configuration.nix -iA system'
hcloud server ssh -u moritz $NAME 'sudo chown -R 0.0 /nix'
hcloud server ssh -u moritz $NAME 'sudo touch /etc/NIXOS'
hcloud server ssh -u moritz $NAME 'sudo touch /etc/NIXOS_LUSTRATE'
hcloud server ssh -u moritz $NAME 'echo etc/nixos | sudo tee -a /etc/NIXOS_LUSTRATE'
#hcloud server ssh -u moritz $NAME 'sudo mv -v /boot /boot.bak'
hcloud server ssh -u moritz $NAME 'sudo rm -R /boot' # to keep /boot/efi mountpoint
hcloud server ssh -u moritz $NAME 'sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot'

# alternatively we could try kexec just for fun
hcloud server reboot $NAME

sleep 30

ssh-keygen -R $(hcloud server ip $NAME)
ssh-keyscan $(hcloud server ip $NAME) >> ~/.ssh/known_hosts

#hcloud server ssh $NAME nix-store --generate-binary-cache-key builder-name cache-priv-key.pem cache-pub-key.pem
hcloud server ssh $NAME nix-channel --update
hcloud server ssh $NAME rm -rf /old-root
hcloud server ssh $NAME nix-collect-garbage -d

hcloud server ssh -u moritz $NAME 'nix-channel --add https://nixos.org/channels/nixos-unstable-small nixpkgs'
hcloud server ssh -u moritz $NAME 'nix-channel --update'

#hcloud server ssh $NAME cat /root/cache-pub-key.pem
#echo write this into your nixos config

date

#hcloud server shutdown $NAME

#sleep 10

#hcloud server create-image --label name=nixos --description "nixos" --type snapshot $NAME

#echo "SERVER DID NOT GET DELETED"
#hcloud server delete $NAME

# server from this script 3:30 until ready (about)
# server from image is about 1 minute
# https://cloudinit.readthedocs.io/en/latest/topics/examples.html

# hcloud server create --datacenter nbg1-dc3 --image $(hcloud image list --output noheader --output columns=id --selector name=nixos) --type cx11 --ssh-key ~/.ssh/id_rsa.pub --name imagetest

# https://github.com/NixOS/nixops
# https://hcloud-python.readthedocs.io/en/latest/
# https://github.com/hetznercloud/hcloud-python/blob/master/examples/create_server.py
