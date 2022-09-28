#!/bin/bash
for i in $( cat $1)
do
        IP="$(echo $i |cut -d '/' -f 1)"
        PREFIX="$( echo $IP |awk 'BEGIN { FS = "." }; {print $1"."$2} ')"
        SUFIX="$(echo $IP |awk 'BEGIN { FS = "." }; {print $3} ')"
        for ADD in $(echo {0..3})
        do
                echo $PREFIX.$SUFIX.0
                ((SUFIX+=1))
        done
done
