#!/usr/bin/env bash
docker_name=ivonet
image=x11-chrome
version=0.2

deploy="false"
#deploy="true"
versioning=false
#versioning=true

#OPTIONS="$OPTIONS --no-cache"
#OPTIONS="$OPTIONS --force-rm"
OPTIONS="$OPTIONS --build-arg APP=X11-chrome --build-arg ADMIN_NAME=x11-chromeadmin --build-arg ADMIN_PASSWORD=secret --build-arg USERNAME=ivonet --build-arg PASSWORD=secret"

docker build ${OPTIONS} -t $docker_name/${image}:latest .
if [ "$?" -eq 0 ] && [ ${deploy} == "true" ]; then
    docker push $docker_name/${image}:latest
fi

if [ "$versioning" == "true" ]; then
    docker tag $docker_name/${image}:latest $docker_name/${image}:${version}
    if [ "$?" -eq 0 ] && [ ${deploy} == "true" ]; then
        docker push $docker_name/${image}:${version}
    fi
fi
