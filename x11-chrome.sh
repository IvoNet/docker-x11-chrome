#!/usr/bin/env bash
NAME=x11-chrome
PORT=10004

quartz() {
    # https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/
    # Command below not needed if socat has been installed as a deamon. It will start x11 when needed
    # See for the deamon in the _config/xquartz folder
#    open -a XQuartz
    ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
    xhost + $ip
}

if [ ! "$(docker ps -q -f name=$NAME)" ]; then

    [[ -z "$(brew ls --versions pulseaudio)" ]] && brew install pulseaudio
    killall pulseaudio 2>/dev/null
    pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon 2>/dev/null

    quartz

    if [ "$(docker ps -aq -f status=exited -f name=$NAME)" ]; then
        echo "Starting existing $NAME container..."
        docker start $NAME
    else
        echo "Starting new $NAME container..."
        docker run                                            \
            -d                                                \
            --name $NAME                                      \
            --rm                                              \
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

    fi
else
    echo "Stopping $NAME..."
    docker stop $NAME
    killall pulseaudio 2>/dev/null
fi

