#!/bin/bash
#!/bin/bash

# - Obtenemos los desktop con wmctrl -d
# - filtramos con grep caracteres de entre # 3 y 4 seguidos de una x 
#   y seguidos de 4 cracteres mas
# - Con head, devolvemos solo la primera coincidencia

M=$(wmctrl -d | grep -oiE '[0-9]{3,4}x[0-9]{3,4}' | head -n 1)


# Separamos el string $M en una array $arr separando por 'x'
IFS='x' read -a arr <<<"$M"

# Ancho
W=${arr[0]}
echo "Ancho Detectado de : "$W" px"

# Alto
H=${arr[1]}
echo "Alto  Detectado de : "$H" px"

# Obteniendo el número de monitores conectados
T=$(xrandr -q | grep -o " connected")

# Separamos el string $T en una array $arrDisplay separando por ' '
IFS=' ' read -a arrDisplay <<<$T

#Contamos 
Monitores=${#arrDisplay[@]}

echo "Monitores Detectados : "$Monitores
#P1=$(( ${arr[0]} / 2 ))

W4=$(( W/4 ))
W2=$(( W/2 ))
W3=$(( (W/4)*3 ))
H2=$(( H/2 ))

W4s=$(( ((W/2)-226)/2 ))
W2s=$(( ((W)-226)/2 ))
W5s=$(( $W2+$W4s ))

wmctrl -s 0
code &
conky &
sleep 15

wmctrl -s 1
/home/alex/.programas/firefoxDev/firefox  http://cristofer.io&
if [ $(cat /sys/block/sda/queue/rotational) == 0 ]
then
  sleep 1
else
  sleep 15
fi

wmctrl -s 2
if [ $Monitores == 1 ]
then
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,0,0,$W2s,$H2
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,$W2s,0,$W2s,$H2
  sleep 1

  wmctrl -s 3
  /home/alex/.programas/firefoxDev/firefox -new-tab -url 4frikis.slack.com -new-tab -url noders.slack.com -new-tab -url izit.slack.com &
  sleep 2

  wmctrl -s 4
  /home/alex/.programas/firefoxDev/firefox -new-window https://izit.signin.aws.amazon.com/console &
  sleep 1
    
else
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,0,0,$W4,$H2
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,$W4,0,$W4,$H2
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,$W2,0,$W4s,$H2
  gnome-terminal &
  sleep 1
  wmctrl -r :ACTIVE: -e 0,$W5s,0,$W4s,$H2
  sleep 1

  wmctrl -s 3
  /home/alex/.programas/firefoxDev/firefox -new-tab -url inbox.google.com -new-tab -url play.spotify.com -new-tab -url bancofalabella.cl -new-tab -url github.com\/login &
  /home/alex/.programas/firefoxDev/firefox -new-tab -url 4frikis.slack.com -new-tab -url noders.slack.com -new-tab -url izit.slack.com &

  sleep 2
  wmctrl -r :ACTIVE: -e 0,$W2,0,$W4s,$H2
  sleep 2

  wmctrl -s 4
  /home/alex/.programas/firefoxDev/firefox -new-window https://izit.signin.aws.amazon.com/console &
  /home/alex/.programas/firefoxDev/firefox -new-window https://izit.signin.aws.amazon.com/console &
  sleep 2
  wmctrl -r :ACTIVE: -e 0,$W2,0,$W4s,$H2
  sleep 2
fi

wmctrl -s 5
nautilus &
