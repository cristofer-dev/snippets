#!/bin/bash
#===============================================================================
#    JackTheStripper v 2.5
#    Official Version for deploy a Debian GNU/Linux server, version 7 (or more)

#    Developed by Eugenia Bahit <eugenia@linux.com>
#    
#    Copyright © 2013, 2014, 2015 Eugenia Bahit <eugenia@linux.com>
#    License: GNU GPL version 3  <http://gnu.org/licenses/gpl.html>.
#    This is free software: you are free to change and redistribute it.
#    There is NO WARRANTY, to the extent permitted by law.
#===============================================================================

# Configuración de colores
resaltado="\033[1m\033[1m"
verde="\033[33m"
normal="\033[1m\033[0m"


# Escribir el título en colores
function write_title() {
    echo " "
    echo -e "$resaltado $1 $normal"
    say_continue
}


# Mostrar mensaje "Done."
function say_done() {
    echo " "
    echo -e "$verde Done. $normal"
    say_continue
}


# Preguntar para continuar
function say_continue() {
    if [ "$pause" == "on" ]; then
        echo -n " Para SALIR, pulse la tecla x; sino, pulse ENTER para continuar..."
        read acc
        if [ "$acc" == "x" ]; then
            exit
        fi
    fi
    echo " "
}


# Obtener la IP del seridor
function __get_ip() {
    linea=`ifconfig eth0 | grep -e "inet\ addr:"`
    serverip=`python scripts/get_ip.py $linea`
    echo $serverip
}


# Copiar archivos de configuración locales
function tunning() {
    whoapp=$1
    cp templates/$whoapp /root/.$whoapp
    cp templates/$whoapp /home/$username/.$whoapp
    chown $username:$username /home/$username/.$whoapp
    say_done
}


# Agregar el comando blockip
function add_command_blockip() {
    echo "  ===> blockip [IP] -- Agregar bloqueo de IP a iptables (OK)"
    echo "  ===> unblockip [IP] -- Eliminar bloqueo de IP en iptables y route (OK)"
    mp=$(__get_manpath)
    
    cp commands/blockip /sbin/jts-iptables
    chmod +x /sbin/jts-iptables
    ln -s /sbin/jts-iptables /sbin/blockip
    ln -s /sbin/jts-iptables /sbin/unblockip

    echo -n "  Agregando páginas man al manual blockip(8) y unblockip(8)"

    cp commands/manpages/blockip $mp/man/man8/blockip.8
    gzip -q $mp/man8/blockip.8
    
    cp commands/manpages/unblockip $mp/man8/unblockip.8
    gzip -q $mp/man8/unblockip.8

    echo " (Listo!)"
}


# Agregar el comando vhostadd
function add_command_vhostadd() {
    echo "  ===> vhostadd -s SERVERNAME [-l [php|python]] -- Agregar nuevo VirtualHost (OK)"
    mp=$(__get_manpath)
    cp commands/vhostadd.tar.gz /sbin/
    
    cp commands/manpages/vhostadd $mp/man8/vhostadd.8
    gzip -q $mp/man8/vhostadd.8

    actualdir=`pwd`
    cd /sbin
    tar -xzvf vhostadd.tar.gz
    cd $actualdir

    echo " (Listo!)"
}


# Agregar el comando europio
function add_command_europio() {
    echo "  ===> europio -- Instalar o actualizar EuropioEngine en el directorio actual (OK)"
    cp commands/europio /sbin/
    chmod +x /sbin/europio

    echo " (Listo!)"
}


# Obtener ruta para las man pages
function __get_manpath() {
    mp=`man --path`
    manpaths=(${mp//:/ })
    for ruta in ${manpaths[*]}; do
        if [ -d "$ruta/man8" ]; then
            target=$ruta
            break
        fi
    done
    echo $target
}


# Pausar antes de continuar
function set_pause_on() {
    if [ "$optional_arg" == "--custom" ]; then
        echo " "
        echo -en "$resaltado Pause Mode (on/off): $normal"; read pause
    else
        pause="on"
    fi
}
