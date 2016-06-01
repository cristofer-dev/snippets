#!/bin/bash

# Configuracion de colores
n="\033[1m\033[0m"
ro1="\033[1;49;31m"
ro7="\033[7;49;31m"
vi1="\033[1;49;35m"
vi7="\033[7;49;35m"


ci1="\033[0;49;36m"

# 0. Verificar si es usuario root o no 
function is_root_user {
    if [ "$USER" != "root" ]; then
        echo "Permiso denegado."
        echo "Este programa solo puede ser ejecutado por el usuario root"
        exit
    else
        clear
    fi
}

function update {
    echo -e "\n$ro7 Actualizando SO                  $n"
    echo -e "\n$ro7 Aplicando UPDATE                 $n"
    echo -e "$ro1 Desea continuar con UPDATE? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando UPDATE... $n"
        apt-get update
        
    else
        echo -e "$vi1 No se aplicara UPDATE $n"
    fi
}

function upgrade {
    echo -e "\n$ro7 Aplicando UPGRADE                $n"
    echo -e "$ro1 Desea aplicar UPGRADE? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando UPGRADE... $n"
        apt-get upgrade
        
    else
        echo -e "$vi1 No se aplicara UPGRADE $n"
    fi
}

# PHP y Apache
function instala_php {
    echo -e "\n$ro7 Se Instalara php5 y Apache       $n"
    echo -e "$ro1 Continuar con la instalacion de PHP5 y Apache? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando Instalacion de PHP5 y Apache... $n"
        apt-get install php5
        service apache2 status
        echo -e "\n$ro1 Instalacion de PHP5 y Apache Finalizada... $n"
    else
        echo -e "$vi1 No se Instalara PHP5 ni Apache $n"
    fi
}



function instala_mysql {
    echo -e "\n$ro7 Se Instalara MySQL Server        $n"
    echo -e "$ro1 Continuar con la instalacion de MySQL Server? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando Instalacion de MySQL Server... $n"
        apt-get install mysql-server
        echo -e "\n$ro1 Instalacion de MySQL Server Finalizada... $n"
    else
        echo -e "$vi1 No se Instalara mysql-server $n"
    fi
}

function conector_phpmysql {
    echo -e "\n$ro7 Se Instalara Conector php5-MySQL $n"
    echo -e "$ro1 Necesario para que php se conecte a MySQL"
    echo -e "$ro1 Continuar con la instalacion de php5-mysql? [y/n]"; read op
    if [ "$op" == "y" ] || [ "$op" == "Y" ]; then
        echo -e "\n Iniciando Instalacion de php5-mysql... $n"
        apt-get install php5-mysql
        echo -e "\n$ro1 Instalacion de php5-mysql Finalizada... $n"
    else
        echo -e "$vi1 No se Instalara php5-mysql $n"
    fi    
}
# Llamando a las funciones

# Verifica que Usuario sea root
is_root_user

#Actualiza Repositorios
update

# Actualizar SO
upgrade

# Instala PHP5 y Apache
instala_php

#Instala MySQL
instala_mysql

#Instala Conector php5-MySQL
conector_phpmysql