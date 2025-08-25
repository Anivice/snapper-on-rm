#!/usr/bin/bash

readonly g_pipe_location="/tmp/snapper-on-rm"

if [ -e $g_pipe_location ]; then
    /usr/bin/rm $g_pipe_location;
fi

if [ -z "$debug" ];
then
    export debug=false
fi

mknod $g_pipe_location p
chmod 0622 $g_pipe_location # rw--w--w-

while true;
do
    while read line < $g_pipe_location;
    do
        if [[ "$line" == "snap" ]];
        then
            name="$(date)"
            if $debug 2>/dev/null;
            then
                echo snapper -c home create -d "$name"
            else
                snapper -c home create -d "$name"
            fi
        elif [[ "$line" == "stop" ]];
        then
            exit 0
        else
            echo "Unknown command \"$line\""
        fi

        sleep .1
    done

    sleep .1
done
