#!/bin/bash
set -e

USERNAME=$(logname)

echo "=== GyroPalm Ubuntu Golden Template Setup ==="
echo "Target user: $USERNAME"
echo

echo "[1/9] Updating apt package index..."
sudo apt update

echo "[2/9] Installing base system utilities..."
sudo apt install -y \
    openssh-server \
    qemu-guest-agent \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    curl \
    wget \
    git \
    htop \
    net-tools \
    dnsutils \
    traceroute \
    nmap \
    jq \
    build-essential \
    unzip \
    zip \
    nano

echo "[3/9] Enabling SSH and QEMU Guest Agent..."

echo "Generating SSH host keys if missing..."
sudo ssh-keygen -A

sudo systemctl enable ssh || echo "Warning: Could not enable SSH. Continuing."
sudo systemctl restart ssh || echo "Warning: Could not start SSH now. Continuing."

sudo systemctl enable qemu-guest-agent || echo "Warning: Could not enable QEMU Guest Agent. Continuing."

echo "[4/9] Adding Docker official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings

sudo rm -f /etc/apt/keyrings/docker.gpg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "[5/9] Adding Docker apt repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[6/9] Installing Docker Engine and Docker Compose..."
sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    docker-compose \
    software-properties-common \
    fail2ban

echo "[7/9] Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[8/9] Adding user '$USERNAME' to docker group..."
if id "$USERNAME" &>/dev/null; then
    sudo usermod -aG docker "$USERNAME"
    echo "User '$USERNAME' added to docker group."
else
    echo "Warning: user '$USERNAME' does not exist. Skipping docker group assignment."
fi

echo "[9/9] Cleaning packages and preparing VM for templating..."
sudo apt autoremove -y
sudo apt clean

echo "Clearing machine-id for clean VM clones..."
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id

echo "Setting timezone to Pacific Time..."
sudo timedatectl set-timezone America/Los_Angeles

echo "Clearing cloud-init state if present..."
sudo cloud-init clean --logs || true

echo "Clearing shell history..."

history -c || true
history -w || true

if id "$USERNAME" &>/dev/null; then
    rm -f "/home/$USERNAME/.bash_history"
fi

rm -f /root/.bash_history

echo
echo "=== Setup complete! ==="
echo "Docker version:"
docker --version || true

echo
echo "Docker Compose version:"
docker compose version || true

echo
echo "Recommended next step:"
echo "Shutdown the VM, then convert it to a Proxmox template."
echo
echo "Example:"
echo "sudo shutdown now"