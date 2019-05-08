#!/usr/bin/env bash
NAME=x11-chrome
PORT=32000
WAIT=3

if [ ! "$(docker ps -q -f name=$NAME)" ]; then

    [[ -z "$(brew ls --versions pulseaudio)" ]] && brew install pulseaudio
    killall pulseaudio 2>/dev/null
    pulseaudio --load=module-native-protocol-tcp --exit-idle-time=-1 --daemon 2>/dev/null


    if [ "$(docker ps -aq -f status=exited -f name=$NAME)" ]; then
        echo "Starting existing $NAME container..."
        docker start $NAME
        sleep $WAIT
        open http://localhost:$PORT
    else
        echo "Starting new $NAME container..."
        docker run                                    \
            -d                                        \
            --name $NAME                              \
            -e PULSE_SERVER=docker.for.mac.localhost  \
            -v ~/.config/pulse:/nobody/.config/pulse  \
            -p $PORT:32000                            \
            ivonet/x11-chrome

        sleep $WAIT
        open http://localhost:$PORT
    fi
else
    echo "Stopping $NAME..."
    docker stop $NAME
    killall pulseaudio 2>/dev/null
fi

