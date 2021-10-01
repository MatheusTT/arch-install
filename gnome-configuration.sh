#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo "Script must be run as a normal user"
    exit
fi

gsettings set org.gnome.desktop.interface gtk-theme     "Matcha-dark-azul"
gsettings set org.gnome.desktop.interface icon-theme    "Papirus"
gsettings set org.gnome.desktop.interface cursor-theme  "cz-Hickson-Black"

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme    "Papirus"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme  "cz-Hickson-Black"

## Mouse/touchpad settings
gsettings set org.gnome.desktop.peripherals.mouse accel-profile   "flat"
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click "true"

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse accel-profile   "flat"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click "true"

## Keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb','br')]"

## Fonts
gsettings set org.gnome.desktop.interface font-name           'Fira Sans 12'
gsettings set org.gnome.desktop.interface document-font-name  'Fira Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Medium 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font  'Fira Sans Bold 12'

## Night-light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

## Other gsettings
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800

gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.desktop.interface enable-hot-corners "true"
gsettings set org.gtk.Settings.FileChooser sort-directories-first "true"