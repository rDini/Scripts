#!/bin/bash

current_track_before=""

while :
do
   current_track=$(playerctl --player=spotify metadata xesam:title)
   if [[ "$current_track" != "$current_track_before" ]]
   then
      img_url=$(playerctl --player=spotify metadata mpris:artUrl)
      img=$(mktemp)
      wget $img_url -O $img -q
      numcol=6
      fuzz=30

      hex="#FFFFFF"
      while [[ "$hex" == "#FFFFFF" && "$fuzz" != "60" ]]
      do
         thresh=$((100-fuzz))
         sortedfinalcolors=`convert $img -scale 50x50! -depth 8 \
         \( -clone 0 -colorspace HSB -channel gb -separate +channel -threshold $thresh% \
         -compose multiply -composite \) \
         -alpha off -compose copy_opacity -composite sparse-color:- |\
         convert -size 50x50 xc: -sparse-color voronoi '@-' \
         +dither -colors $numcol -depth 8 -format "%c" histogram:info: |\
         sed -n 's/^[ ]*\(.*\):.*[#]\([0-9a-fA-F]*\) .*$/\1,#\2/p' | sort -r -n -k 1 -t ","`
         hex1=`echo "$sortedfinalcolors" | head -n 1 | cut -d, -f2`
	 hex2=`echo "$sortedfinalcolors" | head -n 2 | tail -1 | cut -d, -f2`
         ((fuzz+=10))
      done
      sed -i "s/gradient_color_1.*/gradient_color_1 = \'$hex1\'/" $HOME/.config/cava/config
      sed -i "s/gradient_color_2.*/gradient_color_2 = \'$hex2\'/" $HOME/.config/cava/config
      pkill -USR1 cava
   fi
   current_track_before=$current_track
   sleep 1
done
