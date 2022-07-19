#!/bin/sh

#
# Update and install the tools needed
#
sudo pacman -Syu base-devel git

#
# Create a directory for git
#
mkdir -p ~/.git

#
# Enter the created directory
#
cd ~/.git

#
# Install paru from Github
#
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

#
# Install my essential packages
#
paru -Syu firefox ttf-font-awesome kitty ruby-fusuma ttf-font-awesome brightnessctl pamixer wtype acpi grimshot tlp vlc fish

#
# Bring my config files
#
cd ~/
git clone https://github.com/PauLuke/dotfiles
cp -a ~/dotfiles/. ~/.config

#
# Rebooting the system
#
reboot
