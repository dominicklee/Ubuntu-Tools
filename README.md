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

## Colored Text for Ubuntu Server users
If you are running on Ubuntu Live Server, you may not be getting the visual features that Ubuntu Desktop comes with. Colorized terminal text isn't actually a feature of PuTTY itself - it's a feature of the shell inside Ubuntu. On Ubuntu Desktop, colorized directory listings are turned on by default in the user configuration. On a minimal Ubuntu Server install, those built-in color settings are often left commented out or disabled to keep the environment as bare-bones as possible.

On a minimal Ubuntu Server installation, sometimes a user account gets created without the standard template files being copied into the home directory, leaving your `~/.bashrc` completely empty or missing entirely.

Don't worry, we don't have to write one from scratch. Linux keeps a pristine, factory-default backup of the standard Ubuntu `.bashrc` hidden away in a system directory called the "skeleton" folder (`/etc/skel/`).

Copy the factory version directly into your home folder with one command:
```bash
cp /etc/skel/.bashrc ~/.bashrc
```

Then open up the `.bashrc` file:
```bash
nano ~/.bashrc
```

Scroll down, find `#force_color_prompt=yes`, and delete the `#` so it says:
```bash
force_color_prompt=yes
```

Save and exit (Ctrl + O, Enter, then Ctrl + X).

Thne, source it by doing:
```bash
source ~/.bashrc
```

When you connect via PuTTY, Ubuntu treats it as a "Login Shell." When a login shell starts up, it completely ignores the `~/.bashrc` file at first. Instead, it specifically looks for a file called `~/.bash_profile` or `~/.profile` to load your environment.

Run this command in your terminal to copy the missing profile files into your home directory:

```bash
cp /etc/skel/.profile ~/.profile
```

Inside the `~/.profile` file, you will see a piece of code that looks like this:
```bash
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$~/.bashrc" ]; then
	. "$~/.bashrc"
    fi
fi
```

This is the exact bridge we need. Now, every single time you open a brand new PuTTY session and log in, Ubuntu will read `.profile`, see that piece of code, and automatically source your `.bashrc` for you in the background.
