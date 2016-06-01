# !/bin/bash

# Configuracion de colores
n="\033[1m\033[0m"
ro1="\033[1;49;31m"
ro7="\033[7;49;31m"
vi1="\033[1;49;35m"
vi7="\033[7;49;35m"


ci1="\033[0;49;36m"

# 0. Verificar si es usuario root o no 
function is_root_user() {
    if [ "$USER" != "root" ]; then
        echo "Permiso denegado."
        echo "Este programa solo puede ser ejecutado por el usuario root"
        exit
    else
        clear
    fi
}

function new_vhost() {
    echo -e "\n$ro7 Habilitacion de un Visrtual Host          $n"
    echo -e "$ro1 Version 0.1 Para Debian 8.4 y apache 2.4 $n \n"

    echo -e "Ingrese el nombre de dominio local:" ; read hostname
    hostname=$hostname".local"

    echo -e "El has solicitado crear $ro1 $hostname $n en esta maquina"
    echo -e "Desea continuar? [y/n]"; read op
        if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
            echo -e "Creando archivo de configuracion .conf... \n"
            ruta="/etc/apache2/sites-available/$hostname.conf"
            touch $ruta
            echo "<VirtualHost *:80>
        ServerName www.$hostname
        ServerAlias $hostname

        DocumentRoot /srv/websites/$hostname/application
        ErrorLog /srv/websites/$hostname/logs/errors.log
        CustomLog /srv/websites/$hostname/logs/access.log combined

        <Directory /srv/websites/$hostname>
            Options -Indexes
            AllowOverride All
            Require local
        </Directory>
</VirtualHost>" > $ruta
        else
            echo -e " Ha indicado que no"
            echo -e "$ro1 El Script ha finalizado $n \n"
            exit
        fi    
}

function make_dir() {
    echo -e "Creando directorio raiz para el host $ro1$hostname$n... [ $vi1 OK $n ] \n"
    mkdir -p /srv/websites/$hostname/{logs,application}

    touch /srv/websites/$hostname/application/index.html
    echo "Index de Prueba para $hostname" > /srv/websites/$hostname/application/index.html
    echo -e "Creando archivo index.html de prueba... [ $vi1 OK $n ] \n"
}

function permisos() {
    echo -e "Cambiando permisos de la carpeta raiz del host $ro1$hostname$n \n"
    echo -e "Indique el nombre del usuario que trabajara sobre el directorio \n"; read user
    chown -R $user:$user /srv/websites/$hostname
    chmod -R 755 /srv/websites/$hostname
}

function dns() {
    echo "127.0.0.1 $hostname" >> /etc/hosts
    echo -e "Configurando DNS local... [ $vi1 OK $n ]\n"
}

function habilita_vh() {
    echo -e "Habilitando en Apache $ro1$hostname$n ... [ $vi1 OK $n ] \n"
    a2ensite $hostname.conf
} 

function reinicia() {
    echo -e "Reiniciando Apache..."
    service apache2 restart
}

echo -e "Script Finalizado.... \n"
echo -e "Ingresa a $hostname en tu navegador"




is_root_user
new_vhost
make_dir
permisos
dns
habilita_vh
reinicia