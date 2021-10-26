set -ex

# ./hetzner-nix-on-debian.sh -n nix-builder -t ccx32

while getopts t:n: opts; do
   case ${opts} in
      t) TYPE=${OPTARG} ;;
      n) NAME=${OPTARG} ;;
   esac
done

date

hcloud context use nixos
hcloud server create --datacenter nbg1-dc3 --image debian-11 --type $TYPE --ssh-key ~/.ssh/id_rsa.pub --name $NAME

sleep 10

# TODO --user-data-from-file

# https://nixos.org/manual/nix/stable/#sect-single-user-installation
ssh-keygen -R $(hcloud server ip $NAME)
ssh-keyscan $(hcloud server ip $NAME) >> ~/.ssh/known_hosts
hcloud server ssh $NAME 'apt update && apt dist-upgrade -y && reboot'
hcloud server ssh $NAME 'adduser --disabled-password --gecos "" moritz'
hcloud server ssh $NAME 'echo '"'"'moritz ALL=(ALL) NOPASSWD: ALL'"'"' | sudo EDITOR="tee -a" visudo'
hcloud server ssh $NAME 'mkdir /home/moritz/.ssh/'
hcloud server ssh $NAME 'cp .ssh/authorized_keys /home/moritz/.ssh/'
hcloud server ssh $NAME 'chown -R moritz:moritz /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 700 /home/moritz/.ssh'
hcloud server ssh $NAME 'chmod 600 /home/moritz/.ssh/authorized_keys'
hcloud server ssh -u moritz $NAME 'curl -L https://nixos.org/nix/install | sh -s -- --no-daemon'

sudo nano /etc/systemd/logind.conf
RuntimeDirectorySize=90%


date