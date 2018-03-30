#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 VOLUME [BINDING...]"
    exit 1
fi

docker volume inspect $1
if [ "$?" -ne 0 ]; then
    exit 1
fi

if [ "$#" -gt 1 ]; then
    bindings=""
    for arg in ${@:2}; do
        IFS=':' read -r -a binding <<< "$arg"
        if [ "${#binding[@]}" -ne 2 ]; then
            echo "Invalid binding: $arg"
            exit 1
        fi

        bindings="$bindings -v ${binding[0]}:/mnt/bindings/${binding[1]}"
    done
    
    docker run --rm -ti -v $1:/mnt/volume $bindings maksimaleshko/mc:1.0.0 /usr/bin/mc /mnt/volume /mnt/bindings
else
    docker run --rm -ti -v $1:/mnt/volume maksimaleshko/mc:1.0.0 /usr/bin/mc /mnt/volume /mnt/volume
fi
