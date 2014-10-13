#!/bin/sh
icmus="/home/ritsu/.xmonad/icons/music.xbm"
icjam="/home/ritsu/.xmonad/icons/clock.xbm"

musik () {
	if [[ -n "$(mpc current)" ]]; then
		np=$(mpc current)
	else
		np="Music off"
	fi
	echo "^bg()^fg(#CCCCCC)^fn(Terminess Powerline-14)^fn()^bg(#CCCCCC)^fg(#2d2d2d) ^i($icmus) $np "
}

jam () {
	clock=$(date +"%R %p")
	echo "^bg(#CCCCCC)^fg(#ab363f)^fn(Terminess Powerline-14)^fn()^bg(#ab363f)^fg() ^i($icjam) $clock "
}

user () {
	nama="Annisa Ritsu"
	echo "^bg(#ab363f)^fg(#2d2d2d)^fn(Terminess Powerline-14)^fn()^bg()^fg() ^i($icjam) $nama "
}


while :; do
echo "$(musik)$(jam)$(user)^bg()"
sleep 1
done | dzen2 -p -ta r -e 'button3=' -fn 'bitocra-7' -fg '#ffffff' -bg '#2d2d2d' -h 20 -w 666 -x 700
