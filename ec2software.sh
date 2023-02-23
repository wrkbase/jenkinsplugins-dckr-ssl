#!/bin/bash

function err_handle {
	echo "From lineno: $1 exiting with code $2 (last command was: $3)"
	exit "$2"
}

# Trap SIGINT to Stop and Kill all NodeJs Apps
trap 'err_handle "$LINENO" "$?" "$BASH_COMMAND"' ERR


# Install docker on Ubuntu Linux 22.04
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# newgrp docker
sudo usermod -aG docker ${USER}

echo "PLEASE reboot for docker to take effect with : sudo reboot --reboot"
echo
