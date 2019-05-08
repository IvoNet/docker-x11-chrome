#!/usr/bin/env bash
NAME=x11-chrome
PORT=8080
if [ ! -z $1 ]; then
   EP="--entrypoint bash"
fi

killpulse() {
    pulseaudio --kill 2>/dev/null
    killall pulseaudio 2>/dev/null
    rm -rf ~/.config/pulse 2>/dev/null
    mkdir -p ~/.config/pulse 2>/dev/null
}

[[ -z "$(brew ls --versions pulseaudio)" ]] && brew install pulseaudio
killpulse
pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon 2>/dev/null

docker run                                            \
    -it                                               \
    --rm                                              \
    --name $NAME                                      \
    --cpuset-cpus 1                                   \
    --memory 1024mb                                   \
    --net host                                        \
    -v /tmp/.X11-unix:/tmp/.X11-unix                  \
    -e DISPLAY=$ip:0                                  \
    --security-opt seccomp=$HOME/chrome.json          \
    -v /dev/shm:/dev/shm                              \
    -v ${HOME}/.config/ivonet/docker/x11-chrome:/data \
    -e PULSE_SERVER=docker.for.mac.localhost          \
    -v ~/.config/pulse:/nobody/.config/pulse          \
    ivonet/x11-chrome
if [ "$?" != 0 ]; then
    echo "you might want to see if the XQaurtz is still correctly configured. See the xquartz folder."
fi

killpulse
