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
    echo -e "$ro1 Version 0.1 Para Ubuntu 14 y apache 2.4 $n \n"

    echo -e "Ingrese el nombre de dominio local:" ; read hostname
    hostname=$hostname

    echo -e "El has solicitado crear $ro1 $hostname $n en esta maquina"
    echo -e "Desea continuar? [y/n]"; read op
        if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
            echo -e "Creando archivo de configuracion .conf... \n"
            ruta="/etc/apache2/sites-available/$hostname.conf"
            touch $ruta
            echo "<VirtualHost *:80>
        ServerName www.$hostname
        ServerAlias $hostname

        DocumentRoot /var/www/$hostname/application
        ErrorLog /var/www/$hostname/logs/errors.log
        CustomLog /var/www/$hostname/logs/access.log combined

        <Directory /var/www/$hostname>
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
    mkdir -p /var/www/$hostname/{logs,application}

    touch /var/www/$hostname/application/index.html
    echo "Index de Prueba para $hostname" > /var/www/$hostname/application/index.html
    echo -e "Creando archivo index.html de prueba... [ $vi1 OK $n ] \n"
}

function permisos() {
    echo -e "Cambiando permisos de la carpeta raiz del host $ro1$hostname$n \n"
    echo -e "Indique el nombre del usuario que trabajara sobre el directorio \n"; read user
    chown -R $user:$user /var/www/$hostname
    chmod -R 755 /var/www/$hostname
}

function dns() {
    echo "127.0.0.1 $hostname" >> /etc/hosts
    echo -e "Configurando DNS local... [ $vi1 OK $n ]\n"
}

function habilita_vh() {
    echo -e "Habilitando en Apache $ro1$hostname$n ... [ $vi1 OK $n ] \n"
    a2ensite $hostname.conf
}

function habilita_rewrite_engine() {
    echo -e "\n$ro7 Se Habilitara Rewrite Engine de Apache       $n"
    echo -e "$ro1 Confirma habilitacion de Rewrite Engine? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando habilitación Rewrite Engine... $n"
        sudo a2enmod rewrite        
        echo -e "\n$ro1 Habilitacion Rewrite Engine Finalizada... $n"
    else
        echo -e "$vi1 No habilitara Rewrite Engine $n"
    fi    
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
habilita_rewrite_engine
reinicia