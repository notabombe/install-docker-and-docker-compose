#!/bin/bash

# Step 0: Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null
then
    echo "VirtualBox is not installed. Installing VirtualBox..."
    sudo apt-get update
    sudo apt-get install -y virtualbox
else
    echo "VirtualBox is already installed."
fi

# Step 1: Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# Step 2: Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 3: Install Docker Machine
echo "Installing Docker Machine..."
DOCKER_MACHINE_VERSION=$(curl -s https://api.github.com/repos/docker/machine/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
sudo curl -L "https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine

# Step 4: Create a Docker Machine
echo "Creating Docker Machine..."
docker-machine create --driver virtualbox default

# Step 5: Set Docker Machine environment to default
echo "Setting Docker Machine environment to default..."
eval $(docker-machine env default)

echo "Docker, Docker Compose, and Docker Machine have been installed and configured."
