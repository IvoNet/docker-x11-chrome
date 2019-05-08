#!/usr/bin/env bash
#set -xv
check=`which brew`
if [ "$check" = "" ]
then
    echo "Homebrew is missing. Please install from https://brew.sh"
    exit 1
fi
check=`which Xquartz`
if [ "$check" = "" ]
then
    echo "Xquartz is missing. please install with 'brew cask install xquartz'."
    exit 1
fi
check=`which socat`
if [ "$check" = "" ]
then
    echo "socat is missing. please install with 'brew install socat'."
    exit 1
fi
echo "Installing socat launch deamon for X11"
source=ivonet.socat.x11.listener.plist
target=/Library/LaunchDaemons/ivonet.socat.x11.listener.plist

display=$(find /private/tmp -iname "*org.macosforge.xquartz:0" 2>/dev/null)
echo ${display}
sed "s~PLACEHOLDERTOBEREPLACED~${display}~g" ivonet.socat.x11.listener.template.plist > ./${source}
cat ${source}
launchctl unload ${source}
rm -f ${target}
cp $(pwd)/${source} ${target}
chown root:wheel ${target}
sleep 1
launchctl load ${target}
rm -f ${source}
echo "Done."
