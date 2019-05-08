#!/usr/bin/env bash
#set -xv
echo "Uninstalling socat launch deamon for X11"
source=ivonet.socat.x11.listener.plist
target=/Library/LaunchDaemons/ivonet.socat.x11.listener.plist
sudo launchctl unload ${source}
sudo rm -f ${target}
echo "Done."