#!/bin/bash
wmctrl -s 0
/home/alex/.programas/sublimeText3/sublime_text &
conky &
sleep 2

wmctrl -s 1
/home/alex/.programas/firefoxDev/firefox  http://cristofer.io&
sleep 15

wmctrl -s 2
gnome-terminal &
sleep 1
wmctrl -r :ACTIVE: -e 0,0,0,960,540
gnome-terminal &
sleep 1
wmctrl -r :ACTIVE: -e 0,960,0,960,540
gnome-terminal &
sleep 1
wmctrl -r :ACTIVE: -e 0,1920,0,845,540
gnome-terminal &
sleep 1
wmctrl -r :ACTIVE: -e 0,2765,0,845,540
sleep 2

wmctrl -s 3
/home/alex/.programas/firefoxDev/firefox -new-window inbox.google.com &
/home/alex/.programas/firefoxDev/firefox -new-tab -url 4frikis.slack.com -new-tab -url noders.slack.com -new-tab -url izit.slack.com &

sleep 2
wmctrl -r :ACTIVE: -e 0,1920,0,845,540
sleep 2

wmctrl -s 4
/home/alex/.programas/firefoxDev/firefox -new-window https://izit.signin.aws.amazon.com/console &
/home/alex/.programas/firefoxDev/firefox -new-window https://izit.signin.aws.amazon.com/console &
sleep 2
wmctrl -r :ACTIVE: -e 0,1920,0,845,540
sleep 2

wmctrl -s 5
nautilus &
