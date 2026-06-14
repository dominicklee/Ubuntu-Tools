# Ubuntu-Tools
A quick bash script for installing essential packages on a fresh Ubuntu OS

## Overview
Spending over an hour after installing Ubuntu just to set up packages and Docker? Looking up tutorials online repeatedly to put the same tools on your installation? We've put together a script that helps you install common packages along with Docker and Docker Compose.

This script is the perfect essential for setting up a Docker machine, template VM, or something where you just want to get running in just minutes! Feel free to fully inspect the script to see what's included.

## Installation
Single line install makes it easy. Just paste this in your terminal:

```bash
curl -O https://gyropalm.com/downloads/install_ubuntu_tools.sh && chmod +x install_ubuntu_tools.sh && sleep 2 && sudo ./install_ubuntu_tools.sh
```

Grab a coffee. This will take a couple minutes. Once its done, your current logged in user will have Docker privileges and a bunch of helpful tools.