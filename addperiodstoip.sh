#!/bin/bash
for i in $(cat $1)
do
        REV="$(echo $i|rev)"
        QUARTO="$(echo $REV|cut -c -3|rev)"
        TER="$(echo $REV|cut -c 4-6|rev)"
        SEC="$(echo $REV|cut -c 7-9|rev)"
        PRI="$(echo $REV|cut -c 10-|rev)"
        echo "$PRI.$SEC.$TER.$QUARTO"
done
